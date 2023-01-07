class Gforth < Formula
  desc "Implementation of the ANS Forth language"
  homepage "https://www.gnu.org/software/gforth/"
  url "https://ftp.gnu.org/gnu/gforth/gforth-0.7.3.tar.gz"
  sha256 "2f62f2233bf022c23d01c920b1556aa13eab168e3236b13352ac5e9f18542bb0"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gforth"
    rebuild 2
    sha256 mojave: "d97be36156528dafbc6ec06edcf0f4c93706d5ac27a0e192e46468ba9c69a594"
  end

  depends_on "emacs" => :build
  depends_on "libtool"
  uses_from_macos "libffi"

  def install
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make", "EMACS=#{Formula["emacs"].opt_bin}/emacs"
    elisp.mkpath
    system "make", "install", "emacssitelispdir=#{elisp}"

    elisp.install "gforth.elc"
  end

  test do
    assert_equal "2 ", shell_output("#{bin}/gforth -e '1 1 + . bye'")
  end
end
