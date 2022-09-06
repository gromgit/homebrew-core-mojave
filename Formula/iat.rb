class Iat < Formula
  desc "Converts many CD-ROM image formats to ISO9660"
  homepage "https://sourceforge.net/projects/iat.berlios/"
  url "https://downloads.sourceforge.net/project/iat.berlios/iat-0.1.7.tar.bz2"
  sha256 "fb72c42f4be18107ec1bff8448bd6fac2a3926a574d4950a4d5120f0012d62ca"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/iat"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f0f416d11c8b3fc7f734e6f65129ef6225fd903ce1434777b9477947f2a95850"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--includedir=#{include}/iat"
    system "make", "install"
  end

  test do
    system "#{bin}/iat", "--version"
  end
end
