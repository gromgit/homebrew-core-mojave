class CargoCrev < Formula
  desc "Code review system for the cargo package manager"
  homepage "https://web.crev.dev/rust-reviews/"
  url "https://github.com/crev-dev/cargo-crev/archive/refs/tags/v0.23.3.tar.gz"
  sha256 "c66a057df87dda209ecca31d83da7ef04117a923d9bfcc88c0d505b30dabf29b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cargo-crev"
    sha256 cellar: :any_skip_relocation, mojave: "fa7755cb627f8fd03d7b058aed252e37c889c5ba84df4f4ccf170b8547a164fa"
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
