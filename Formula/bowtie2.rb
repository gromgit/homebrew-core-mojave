class Bowtie2 < Formula
  desc "Fast and sensitive gapped read aligner"
  homepage "https://bowtie-bio.sourceforge.io/bowtie2/"
  url "https://github.com/BenLangmead/bowtie2/archive/v2.5.0.tar.gz"
  sha256 "55dedeba8bea240d3ce3f46211d6e14310035c1de5a3e9ac33f72f739165fea0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bowtie2"
    sha256 cellar: :any_skip_relocation, mojave: "8a884a333ee5afb58b589e4f486860e83f0688927e5812124724337504067d17"
  end

  uses_from_macos "perl"
  uses_from_macos "python", since: :catalina
  uses_from_macos "zlib"

  on_arm do
    depends_on "simde" => :build
  end

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
