class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v5.0.5.tar.gz"
  sha256 "f8cd45546f3ce1e59e88b5861c1ba538039b39e7802749fff659a6367f097402"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/macchina"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "caf82cd9f33bedf80c74733df67d2ab17f1f2bbe9f3246f0f582845655bdaf05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
