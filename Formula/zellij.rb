class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/v0.31.4.tar.gz"
  sha256 "286b08523457cdadee89bb1839f8d08ac402af00f3e27063520a7ed9ee7afc8a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zellij"
    sha256 cellar: :any_skip_relocation, mojave: "a2849f2eb9599b4069c1f039572047e555f7e97bf5fb0edc28aa4ec591d24381"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match(/keybinds:.*/, shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
