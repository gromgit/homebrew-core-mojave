class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.6.14.tar.gz"
  sha256 "d67af3efacc181c20b3b0a4f16616e74d19565498e56ab78ca5867fa71564b59"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/observerward"
    sha256 cellar: :any_skip_relocation, mojave: "a06ddf01890887e410bac9e4d79225485ddb28081fbeba4e04d9ef7ebcef7d3c"
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
