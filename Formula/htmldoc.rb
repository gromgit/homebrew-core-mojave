class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.13.tar.gz"
  sha256 "e020936267afe2c36d9cecd96a054994947207cbe231c94f59c98e08ca24dd37"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htmldoc"
    rebuild 1
    sha256 mojave: "09771de9f1d82be2e969e1d07079ad23547f1fc231cab64539472b2d09c83cd5"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-ssl",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/htmldoc", "--version"
  end
end
