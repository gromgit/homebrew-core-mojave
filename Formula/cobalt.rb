class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.3.tar.gz"
  sha256 "32350ef91a0c1dd81b75e8eb94f5a591ca91bd35d1a6d97622996b1086d5ced2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cobalt"
    sha256 cellar: :any_skip_relocation, mojave: "32de5675f9c875c71c0e6d08fac0cdb3f8a852172bed1baf7e85a755409da3e9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"cobalt", "init"
    system bin/"cobalt", "build"
    assert_predicate testpath/"_site/index.html", :exist?
  end
end
