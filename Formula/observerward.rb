class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.8.25.tar.gz"
  sha256 "c2ccbc57c3e2ba85bc17908d4af3fc710fc619a27a16c48b8eb0e3a8e465f803"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/observerward"
    sha256 cellar: :any_skip_relocation, mojave: "00216cd91e53183cad55f2b0f6fa64b9bf9ed6aa1941e8ba81f30da9172d3269"
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
