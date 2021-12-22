class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.22.1.tar.gz"
  sha256 "8d71fc7fbca1f89e4a20b87f4e149ee4a97644b7d4807201c50cd9178a0feb57"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zellij"
    sha256 cellar: :any_skip_relocation, mojave: "c6e5d34bd8534fff02e19888674ac2792d280cd8b9701fe853ac32918f0065fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "bash")
    (bash_completion/"zellij").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "zsh")
    (zsh_completion/"_zellij").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"zellij", "setup", "--generate-completion", "fish")
    (fish_completion/"zellij.fish").write fish_output
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
