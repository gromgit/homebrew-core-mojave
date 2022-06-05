class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2022.6.1.tar.gz"
  sha256 "61f615c77799c6681d0f37ea963d833ff586c81978f4f62d723967216942f91f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/observerward"
    sha256 cellar: :any_skip_relocation, mojave: "072974cf0d65e4e123e324ad89cdbdf9fa9f41d0102b6642dc0212254677be84"
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
