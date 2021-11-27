class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.4.0/qpdf-10.4.0.tar.gz"
  sha256 "9ac6e691cc3f35a9fe44632e3fba727e1b6ef21181c0a883287abf5cf97ae222"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qpdf"
    rebuild 1
    sha256 cellar: :any, mojave: "bcfc3e80865e065a3d4ed587936ac6039a82a15dfb7b9e9f86f1fa81500c8504"
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
