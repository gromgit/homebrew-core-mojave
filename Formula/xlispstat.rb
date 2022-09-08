class Xlispstat < Formula
  desc "Statistical data science environment based on Lisp"
  homepage "https://homepage.stat.uiowa.edu/~luke/xls/xlsinfo/"
  url "https://homepage.cs.uiowa.edu/~luke/xls/xlispstat/current/xlispstat-3-52-23.tar.gz"
  version "3.52.23"
  sha256 "9bf165eb3f92384373dab34f9a56ec8455ff9e2bf7dff6485e807767e6ce6cf4"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xlispstat"
    rebuild 1
    sha256 cellar: :any, mojave: "7225bb3c12056167362bc963b69b6e07e1c4424a93118e4fd5ce527d247f521f"
  end

  depends_on "libx11"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    ENV.deparallelize # Or make fails bytecompiling lisp code
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "> 50.5\n> ", pipe_output("#{bin}/xlispstat | tail -2", "(median (iseq 1 100))")
  end
end
