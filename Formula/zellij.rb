class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.21.0.tar.gz"
  sha256 "5cd2e9d24380b62a85f22b18462fa9873202f3dd2b9020b513613f156ac1f37d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zellij"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "43ec3166785f8b477741c921c2b2b024c0c7126e30388033ff613191f60e7ebc"
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
