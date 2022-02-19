class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.2/qpdf-10.6.2.tar.gz"
  sha256 "4b8c966300fcef32352f6576b7ef40167e080e43fe8954b12ef80b49a7e5307f"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qpdf"
    sha256 cellar: :any, mojave: "db82b5f59743beeda6457af2899daed2f49a81504ef3669cbdd91e9360af03b4"
  end

  depends_on "jpeg"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
