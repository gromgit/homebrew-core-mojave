class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.5.tar.gz"
  sha256 "db101391b54a5e0eeed7469b05aee55ee6299558b38607f592f6b35a7d41dcb6"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bowtie2"
    sha256 cellar: :any_skip_relocation, mojave: "bb5b965c77761b0851cadb708bd6ca1576d261d6a09c63eef6954982b5db0e5b"
  end

  depends_on "simde"
  depends_on "tbb"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "example", "scripts"
  end

  test do
    system "#{bin}/bowtie2-build",
           "#{pkgshare}/example/reference/lambda_virus.fa", "lambda_virus"
    assert_predicate testpath/"lambda_virus.1.bt2", :exist?,
                     "Failed to create viral alignment lambda_virus.1.bt2"
  end
end
