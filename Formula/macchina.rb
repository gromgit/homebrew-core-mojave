class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v5.0.5.tar.gz"
  sha256 "f8cd45546f3ce1e59e88b5861c1ba538039b39e7802749fff659a6367f097402"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/macchina"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "aaf70803f11636acecdeb2ca897fca747bb481663b8ee693f8cd2b8f93df7984"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
