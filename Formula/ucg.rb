class Ucg < Formula
  desc "Tool for searching large bodies of source code (like grep)"
  homepage "https://github.com/gvansickle/ucg"
  url "https://github.com/gvansickle/ucg/releases/download/0.3.3/universalcodegrep-0.3.3.tar.gz"
  sha256 "116d832bbc743c7dd469e5e7f1b20addb3b7a08df4b4441d59da3acf221caf2d"
  license "GPL-3.0-or-later"
  head "https://github.com/gvansickle/ucg.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ucg"
    rebuild 2
    sha256 cellar: :any, mojave: "54c89e91e4ad419b606e8caf4b26ec22e7a3a2cd68bca07715dbeb00de93122c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre2"

  on_macos do
    depends_on "argp-standalone" => :build
  end

  # Fix Xcode 9 compilation issue: https://github.com/gvansickle/ucg/issues/118
  # Patch adapted from upstream: https://github.com/gvansickle/ucg/commit/395f89
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/00615b433f5d2e3eaaf0075fbf4c63d0d732f8c8/ucg/xcode9.patch"
    sha256 "3005fda5923cfa3093ce53ad84435fd7a5974f960b2e222e0e59afa90414af90"
  end

  def install
    system "autoreconf", "-i" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    assert_match "Hello World!", shell_output("#{bin}/ucg 'Hello World' #{testpath}")
  end
end
