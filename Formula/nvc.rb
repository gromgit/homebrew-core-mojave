class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.7.0/nvc-1.7.0.tar.gz"
  sha256 "bc10ec3777b457582a66bb94f97c614d8d83956547aee4c658402da6e2474b32"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nvc"
    sha256 mojave: "4ba8a24f8746e34736e8a63eb70886ced8655c52d785dcc1d18006216d06aea6"
  end

  head do
    url "https://github.com/nickg/nvc.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "flex" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  resource "homebrew-test" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b"
  end

  patch do
    # Fix build with glibc < 2.36
    # Remove in the next release
    on_linux do
      url "https://github.com/nickg/nvc/commit/3f1a495360d4c97bf6537e62eb77c1269297dcb2.patch?full_index=1"
      sha256 "d5bda0f89c346f618b9bc5ce96095be5bb9eb8e0fec3caea4ebddfe1ae2dee23"
    end
  end

  def install
    system "./autogen.sh" if build.head?

    # Avoid hardcoding path to the `ld` shim.
    inreplace "configure", "#define LINKER_PATH \\\"$linker_path\\\"", "#define LINKER_PATH \\\"ld\\\"" if OS.linux?

    # In-tree builds are not supported.
    mkdir "build" do
      system "../configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                             "--prefix=#{prefix}",
                             "--with-system-cc=#{ENV.cc}",
                             "--disable-silent-rules"
      inreplace ["Makefile", "config.h"], Superenv.shims_path/ENV.cc, ENV.cc
      ENV.deparallelize
      system "make", "V=1"
      system "make", "V=1", "install"
    end
  end

  test do
    resource("homebrew-test").stage testpath
    system bin/"nvc", "-a", testpath/"basic_library/very_common_pkg.vhd"
  end
end
