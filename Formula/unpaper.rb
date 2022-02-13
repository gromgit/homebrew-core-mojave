class Unpaper < Formula
  desc "Post-processing for scanned/photocopied books"
  homepage "https://www.flameeyes.com/projects/unpaper"
  url "https://www.flameeyes.com/files/unpaper-6.1.tar.xz"
  sha256 "237c84f5da544b3f7709827f9f12c37c346cdf029b1128fb4633f9bafa5cb930"
  license "GPL-2.0-or-later"
  revision 8

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/unpaper"
    sha256 cellar: :any, mojave: "d6cfb40c2b0d2012968a1b798ebb79fa6680cc0b1c99f20cb80696844536033f"
  end

  head do
    url "https://github.com/Flameeyes/unpaper.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "libxslt"

  on_linux do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "autoreconf", "-i" if build.head?

    system "autoreconf", "-i" if OS.linux?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.pbm").write <<~EOS
      P1
      6 10
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      0 0 0 0 1 0
      1 0 0 0 1 0
      0 1 1 1 0 0
      0 0 0 0 0 0
      0 0 0 0 0 0
    EOS
    system bin/"unpaper", testpath/"test.pbm", testpath/"out.pbm"
    assert_predicate testpath/"out.pbm", :exist?
  end
end
