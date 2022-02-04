class Procs < Formula
  desc "Modern replacement for ps written by Rust"
  homepage "https://github.com/dalance/procs"
  url "https://github.com/dalance/procs/archive/v0.12.1.tar.gz"
  sha256 "ce84e98dd85cb8d5afda871ad2ddceb4faec077d9e019469aa668a75821e4fc2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/procs"
    sha256 cellar: :any_skip_relocation, mojave: "e02e2c7d23a73bce091d240b79a125ad6dc0ecdf2a83e55e93125d16de1fc306"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"procs", "--completion", "bash"
    system bin/"procs", "--completion", "fish"
    system bin/"procs", "--completion", "zsh"
    bash_completion.install "procs.bash" => "procs"
    fish_completion.install "procs.fish"
    zsh_completion.install "_procs"
  end

  test do
    output = shell_output(bin/"procs")
    count = output.lines.count
    assert count > 2
    assert output.start_with?(" PID:")
  end
end
