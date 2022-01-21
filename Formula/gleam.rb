class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.19.0.tar.gz"
  sha256 "4aeadce8a4ecb56f4c66190b8cc97702f7dfccf2bb4b9ffe18b2de2317f55d84"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gleam"
    sha256 cellar: :any_skip_relocation, mojave: "c985a68b08474512e43a1f2e1be630c295559d05da5bf3ada5a233a96de65811"
  end

  depends_on "rust" => :build
  depends_on "erlang"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "compiler-cli")
  end

  test do
    Dir.chdir testpath
    system bin/"gleam", "new", "test_project"
    Dir.chdir "test_project"
    system "gleam", "test"
  end
end
