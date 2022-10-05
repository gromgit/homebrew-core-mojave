class Taplo < Formula
  desc "TOML toolkit written in Rust"
  homepage "https://taplo.tamasfe.dev"
  url "https://github.com/tamasfe/taplo/archive/refs/tags/release-taplo-cli-0.7.0.tar.gz"
  sha256 "6b6d06220dabc3a63e17b87ca4be1b9dfde97dc3c6bd6e8115cc5d2e2dad9bbe"
  license "MIT"
  head "https://github.com/tamasfe/taplo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release-taplo-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/taplo"
    sha256 cellar: :any_skip_relocation, mojave: "359313b734fb774b0463255eead033cbab7fbb0753b0668181f722799e923794"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "lsp", *std_cargo_args(path: "crates/taplo-cli")
  end

  test do
    (testpath/"invalid.toml").write <<~EOS
      # INVALID TOML DOC
      fruit = []

      [[fruit]] # Not allowed
    EOS

    assert_match("invalid TOML", shell_output("#{bin}/taplo lint invalid.toml 2>&1", 1))
  end
end
