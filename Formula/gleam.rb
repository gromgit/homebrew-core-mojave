class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.23.0.tar.gz"
  sha256 "d5b159474be38c3e4c54c3b54442c306a1137f8602141e1545d67e9b8f4c22bc"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gleam"
    sha256 cellar: :any_skip_relocation, mojave: "da389eda861e1697e779d2ff8501c6acdffb98bb789732e9a3e6aaa1924c3161"
  end

  depends_on "rust" => :build
  depends_on "erlang"
  depends_on "rebar3"

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
