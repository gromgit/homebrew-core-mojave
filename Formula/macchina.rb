class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.1.5.tar.gz"
  sha256 "0df28be92649746ebe4dec13c1a4f95e877cea2ece8ee463e836c0004555248d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/macchina"
    sha256 cellar: :any_skip_relocation, mojave: "c7ed307dea96a109803300a16663586043c38937aaed34496859145b376777f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
