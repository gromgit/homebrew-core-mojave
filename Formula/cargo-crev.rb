class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.23.2.tar.gz"
  sha256 "b37ca10e252bcd352634aed7ea366dfa84900446dbd74888f3178c0c10068d10"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-crev"
    sha256 cellar: :any_skip_relocation, mojave: "110d070b9c5f593ed51ed1c56dcaeb2dc0348dd249336af5f28e57513210a641"
  end

  depends_on "rust" => [:build, :test]

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "./cargo-crev")
  end

  test do
    system "cargo", "crev", "config", "dir"
  end
end
