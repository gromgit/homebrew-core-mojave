class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.21.0.tar.gz"
  sha256 "9abd3ec53a2c7758e59d7f9d30ecff25cf193e7c161f380d71293a2d5b82e098"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gleam"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "50f280cae4c5e01e8fef2e235cd2dfcf41f03cc526787d406c016edad97cf8e6"
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
