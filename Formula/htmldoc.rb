class Htmldoc < Formula
  desc "Convert HTML to PDF or PostScript"
  homepage "https://www.msweet.org/htmldoc/"
  url "https://github.com/michaelrsweet/htmldoc/archive/v1.9.13.tar.gz"
  sha256 "e020936267afe2c36d9cecd96a054994947207cbe231c94f59c98e08ca24dd37"
  license "GPL-2.0-only"
  head "https://github.com/michaelrsweet/htmldoc.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htmldoc"
    rebuild 2
    sha256 mojave: "d5970bc7226be7d8c446c7df5808a02b77a6b06f7ea7f7684410705cf7f4bb00"
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
