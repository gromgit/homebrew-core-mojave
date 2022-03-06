class Blockhash < Formula
  desc "Perceptual image hash calculation tool"
  homepage "https://github.com/commonsmachinery/blockhash"
  url "https://github.com/commonsmachinery/blockhash/archive/v0.3.2.tar.gz"
  sha256 "add1e27e43b35dde56e44bc6d1f0556facf4a18a0f9072df04d4134d8f517365"
  license "MIT"
  head "https://github.com/commonsmachinery/blockhash.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/blockhash"
    rebuild 2
    sha256 cellar: :any, mojave: "a391f2a1d7725c27d3546df215e36a23414b5bc56f4740abb6957296c88b70ea"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "imagemagick"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/commonsmachinery/blockhash/ce08b465b658c4e886d49ec33361cee767f86db6/testdata/clipper_ship.jpg"
    sha256 "a9f6858876adadc83c8551b664632a9cf669c2aea4fec0c09d81171cc3b8a97f"
  end

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    # pkg-config adds -fopenmp flag during configuring
    # This fails the build on system clang, and OpenMP is not used in blockhash
    inreplace "build/c4che/_cache.py", "-fopenmp", ""
    system "python3", "./waf"
    system "python3", "./waf", "install"
  end

  test do
    resource("homebrew-testdata").stage testpath
    hash = "00007ff07ff07fe07fe67ff07560600077fe701e7f5e000079fd40410001ffff"
    result = shell_output("#{bin}/blockhash #{testpath}/clipper_ship.jpg")
    assert_match hash, result
  end
end
