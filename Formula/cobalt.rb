class Cobalt < Formula
  desc "Static site generator written in Rust"
  homepage "https://cobalt-org.github.io/"
  url "https://github.com/cobalt-org/cobalt.rs/archive/v0.17.5.tar.gz"
  sha256 "17603490ba4817ec6ab3c486e39ac5863dd8625b58d8f8bfb534c83d7af334ef"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cobalt"
    sha256 cellar: :any_skip_relocation, mojave: "c8162136a8f50cca4b6b72f04a12e929ad41b9a84dda562087682862db355b28"
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
