class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.6.tar.gz"
  sha256 "da77e1899b13e4612b5ca6a22e8e266beabc734153e7a59c7c8b82c142510435"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/macchina"
    sha256 cellar: :any_skip_relocation, mojave: "76ae07bbcbf0726165c7635cc666e4cb7a7703b240094e1bf6246cd8f5237ada"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
