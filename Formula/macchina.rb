class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v6.0.5.tar.gz"
  sha256 "88de2c9718e071dcd9486cf1e7d87d46533100e589d99cd7b18ff43c21a8a053"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/macchina"
    sha256 cellar: :any_skip_relocation, mojave: "4ef2a4e83787467cbaf6637b830d2ba1d33a9ca97571730e95f1a25f9356fe3e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
