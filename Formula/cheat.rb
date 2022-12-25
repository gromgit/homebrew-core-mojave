class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/refs/tags/4.4.0.tar.gz"
  sha256 "8694d75896dcb1dfb91ed95ec37f7fe409ad2bde76e66f80b20be24ee92ae3ec"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cheat"
    sha256 cellar: :any_skip_relocation, mojave: "1e0834f62a19e0763ea5b0b8cd77694353b0fdf7778423995b528c8b811cc391"
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", because: "both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
    zsh_completion.install "scripts/cheat.zsh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: EDITOR_PATH", output
  end
end
