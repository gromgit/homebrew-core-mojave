class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.4.5.tar.gz"
  sha256 "db101391b54a5e0eeed7469b05aee55ee6299558b38607f592f6b35a7d41dcb6"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bowtie2"
    sha256 cellar: :any_skip_relocation, mojave: "52c467411d45f1b891e593d7481e46480894174c46aaa9fc7fd117167fb4095e"
  end

  depends_on "simde"
  depends_on "tbb"

  uses_from_macos "python"
  uses_from_macos "zlib"

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
