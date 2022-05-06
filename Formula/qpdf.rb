class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.3/qpdf-10.6.3.tar.gz"
  sha256 "e8fc23b2a584ea68c963a897515d3eb3129186741dd19d13c86d31fa33493811"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^release-qpdf[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qpdf"
    rebuild 1
    sha256 cellar: :any, mojave: "86cea0e345625a3c5e88210140af1d10703290fcfa09bb86d276d91545008d89"
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
