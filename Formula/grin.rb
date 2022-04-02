class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/v5.1.2.tar.gz"
  sha256 "a4856335d88630e742b75e877f1217d7c9180b89f030d2e1d1c780c0f8cc475c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grin"
    sha256 cellar: :any_skip_relocation, mojave: "9a52a62dd8896d38dadb60d488afbb8e588a598a4e751dd39de212c09871bb4c"
  end

  depends_on "llvm" => :build # for libclang
  depends_on "rust" => :build

  uses_from_macos "ncurses"

  def install
    ENV["CLANG_PATH"] = Formula["llvm"].opt_bin/"clang"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
