class Scotch < Formula
  desc "Package for graph partitioning, graph clustering, and sparse matrix ordering"
  homepage "https://gitlab.inria.fr/scotch/scotch"
  url "https://gitlab.inria.fr/scotch/scotch/-/archive/v7.0.0/scotch-v7.0.0.tar.bz2"
  sha256 "a36a26c89b6eeb0ffcda8378fb29dd98a2589a47be93c67b59e00374c878054a"
  license "CECILL-C"
  head "https://gitlab.inria.fr/scotch/scotch.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scotch"
    sha256 cellar: :any, mojave: "f16dd08b00e1b234d3ea5b166b93bf89b1756f0d8e17dfd7218b3ef2cec0ceda"
  end

  depends_on "bison" => :build
  depends_on "open-mpi"

  uses_from_macos "flex" => :build
  uses_from_macos "zlib"

  def install
    makefile_inc_suffix = OS.mac? ? "i686_mac_darwin10" : "x86-64_pc_linux2"
    (buildpath/"src").install_symlink "Make.inc/Makefile.inc.#{makefile_inc_suffix}" => "Makefile.inc"

    cd "src" do
      inreplace_files = ["Makefile.inc"]
      inreplace_files << "Make.inc/Makefile.inc.#{makefile_inc_suffix}.shlib" unless OS.mac?

      inreplace inreplace_files do |s|
        s.change_make_var! "CCS", ENV.cc
        s.change_make_var! "CCP", "mpicc"
        s.change_make_var! "CCD", "mpicc"
      end

      system "make", "libscotch", "libptscotch"
      lib.install buildpath.glob("lib/*.a")
      system "make", "realclean"

      # Build shared libraries. See `Makefile.inc.*.shlib`.
      if OS.mac?
        inreplace "Makefile.inc" do |s|
          s.change_make_var! "LIB", ".dylib"
          s.change_make_var! "AR", ENV.cc
          s.change_make_var! "ARFLAGS", "-shared -Wl,-undefined,dynamic_lookup -o"
          s.change_make_var! "CLIBFLAGS", "-shared -fPIC"
          s.change_make_var! "RANLIB", "true"
        end
      else
        Pathname("Makefile.inc").unlink
        ln_sf "Make.inc/Makefile.inc.#{makefile_inc_suffix}.shlib", "Makefile.inc"
      end

      system "make", "scotch", "ptscotch"
      system "make", "prefix=#{prefix}", "install"

      pkgshare.install "check/test_strat_seq.c"
      pkgshare.install "check/test_strat_par.c"
    end

    # License file has a non-standard filename
    prefix.install buildpath.glob("LICEN[CS]E_*.txt")
    doc.install (buildpath/"doc").children
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <stdio.h>
      #include <scotch.h>
      int main(void) {
        int major, minor, patch;
        SCOTCH_version(&major, &minor, &patch);
        printf("%d.%d.%d", major, minor, patch);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lscotch", "-lscotcherr",
                             "-pthread", "-L#{Formula["zlib"].opt_lib}", "-lz", "-lm"
    assert_match version.to_s, shell_output("./a.out")

    system ENV.cc, pkgshare/"test_strat_seq.c", "-o", "test_strat_seq",
                   "-I#{include}", "-L#{lib}", "-lscotch", "-lscotcherr", "-lm", "-pthread",
                   "-L#{Formula["zlib"].opt_lib}", "-lz"
    assert_match "Sequential mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_seq")

    system "mpicc", pkgshare/"test_strat_par.c", "-o", "test_strat_par",
                    "-I#{include}", "-L#{lib}", "-lptscotch", "-lscotch", "-lptscotcherr", "-lm", "-pthread",
                    "-L#{Formula["zlib"].opt_lib}", "-lz", "-Wl,-rpath,#{lib}"
    assert_match "Parallel mapping strategy, SCOTCH_STRATDEFAULT", shell_output("./test_strat_par")
  end
end
