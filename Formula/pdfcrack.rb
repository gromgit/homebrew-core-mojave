class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.20/pdfcrack-0.20.tar.gz"
  sha256 "7b8b29b18fcd5cb984aeb640ee06edf09fede4709b59c32fee4f2d86860de5b4"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pdfcrack"
    sha256 cellar: :any_skip_relocation, mojave: "bdefa2bec7030874fe0866750b270fc8ccada42135428ad6d3ee8972339efa8a"
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end

  test do
    system "#{bin}/pdfcrack", "--version"
  end
end
