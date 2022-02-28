class Gleam < Formula
  desc "✨ A statically typed language for the Erlang VM"
  homepage "https://gleam.run"
  url "https://github.com/gleam-lang/gleam/archive/v0.20.1.tar.gz"
  sha256 "2cd909bdef561b480a536be20606a7617d19680e067c8d4a14d0f05fb6a0cd22"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gleam"
    sha256 cellar: :any_skip_relocation, mojave: "ce940ac6ba6b71b32ac6c99749110b5cafe854616011578de6b15b2b441fc0b2"
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
