class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.9.6.tar.gz"
  sha256 "230434f4a19a19d0d1428ecf0e8224d56a3ce2a15796d06de28611d7234db060"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/observerward"
    sha256 cellar: :any_skip_relocation, mojave: "7d0088036981d84bdd03bcaf0f8aa1b25ba0695c4e0000bce747b855de6d356f"
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
