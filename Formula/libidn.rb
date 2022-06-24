class Libidn < Formula
  desc "International domain name library"
  homepage "https://www.gnu.org/software/libidn/"
  url "https://ftp.gnu.org/gnu/libidn/libidn-1.40.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn-1.40.tar.gz"
  sha256 "527f673b8043d7189c056dd478b07af82492ecf118aa3e0ef0dc98c11af79991"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libidn"
    sha256 mojave: "c491a0bd23118077decc021b34c5925c295c187fb8ea969c0bb5b0c1bbf8e014"
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-csharp",
                          "--with-lispdir=#{elisp}"
    system "make", "install"
  end

  test do
    ENV["CHARSET"] = "UTF-8"
    system bin/"idn", "räksmörgås.se", "blåbærgrød.no"
  end
end
