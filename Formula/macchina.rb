class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.1.tar.gz"
  sha256 "9752386497b83ff9aed90ab7d762495a78fcef276d8ddca28d9781ce391d4cf2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/macchina"
    sha256 cellar: :any_skip_relocation, mojave: "9dd1f54dcd6ad31c91845c514515c8aa96479382ed82979dc2406a6bc64e542f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
