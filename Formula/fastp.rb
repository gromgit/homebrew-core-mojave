class Fastp < Formula
  desc "Ultra-fast all-in-one FASTQ preprocessor"
  homepage "https://github.com/OpenGene/fastp"
  url "https://github.com/OpenGene/fastp/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "185bd58732e57474fa08aae90e154fbc05f3e437ee2b434386dd2266d60d8ef6"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fastp"
    sha256 cellar: :any, mojave: "c508b1ade716e2babc20e2390836c71683ed715b63af9c514e8f57eeefac43cd"
  end

  depends_on arch: :x86_64 # isa-l is not supported on ARM
  depends_on "isa-l"
  depends_on "libdeflate"

  def install
    mkdir prefix/"bin"
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "testdata"
  end

  test do
    system bin/"fastp", "-i", pkgshare/"testdata/R1.fq", "-o", "out.fq"
    assert_predicate testpath/"out.fq", :exist?
  end
end
