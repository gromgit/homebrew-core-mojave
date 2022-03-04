class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://github.com/periscop/cloog"
  url "https://github.com/periscop/cloog/releases/download/cloog-0.20.0/cloog-0.20.0.tar.gz"
  sha256 "835c49951ff57be71dcceb6234d19d2cc22a3a5df84aea0a9d9760d92166fc72"
  license "LGPL-2.1-or-later"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cloog"
    sha256 cellar: :any, mojave: "85ca932c1f21f44799fd1ef8c789bf2203c7a2de19c809c1c25ee93046bc9c34"
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "isl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Avoid doc build.
    ENV["ac_cv_prog_TEXI2DVI"] = ""

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{Formula["isl"].opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cloog").write <<~EOS
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    assert_match %r{Generated from #{testpath}/test.cloog by CLooG},
                 shell_output("#{bin}/cloog #{testpath}/test.cloog")
  end
end
