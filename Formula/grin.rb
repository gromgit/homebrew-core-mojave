class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  # TODO: remove the `cargo update` line when this is next updated (5.2.x).
  url "https://github.com/mimblewimble/grin/archive/v5.1.2.tar.gz"
  sha256 "a4856335d88630e742b75e877f1217d7c9180b89f030d2e1d1c780c0f8cc475c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grin"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "3d728fd4ab7563850d6e067510b8930052cee7605d51eca76b3c164544523c00"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  uses_from_macos "ncurses"

  def install
    # Fixes compile with newer Rust.
    # REMOVE ME in the next release.
    system "cargo", "update", "--package", "socket2", "--precise", "0.3.16"

    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
