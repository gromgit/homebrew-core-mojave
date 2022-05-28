class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.5.19.tar.gz"
  sha256 "1555c3ce9f1f49b2f1d31d6475b0379ac28628eb1b5e674855c2408277c47d1a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/observerward"
    sha256 cellar: :any_skip_relocation, mojave: "e85c2d9f148439941ebdc8a294eba921fd939247965db904e94a7f362fc2c0ef"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "swagger", shell_output("#{bin}/observer_ward -t https://httpbin.org")
  end
end
