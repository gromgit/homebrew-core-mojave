class Tealdeer < Formula
  desc "Very fast implementation of tldr in Rust"
  homepage "https://github.com/dbrgn/tealdeer"
  url "https://github.com/dbrgn/tealdeer/archive/v1.5.0.tar.gz"
  sha256 "00902a50373ab75fedec4578c6c2c02523fad435486918ad9a86ed01f804358a"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tealdeer"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "883265f48177b858b8284fd81ba58832d9e14827896b2694848ebe5a1cc8933c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  conflicts_with "tldr", because: "both install `tldr` binaries"

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
    bash_completion.install "bash_tealdeer" => "tldr"
    zsh_completion.install "zsh_tealdeer" => "_tldr"
    fish_completion.install "fish_tealdeer" => "tldr.fish"
  end

  test do
    assert_match "brew", shell_output("#{bin}/tldr -u && #{bin}/tldr brew")
  end
end
