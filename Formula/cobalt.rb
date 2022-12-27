class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.18.3.tar.gz"
  sha256 "32350ef91a0c1dd81b75e8eb94f5a591ca91bd35d1a6d97622996b1086d5ced2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cobalt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cc2099d74a2f6db98dcce19721262fe84b1d3dedc2cc8850e1dcb131d041d958"
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
