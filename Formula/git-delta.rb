class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.12.1.tar.gz"
  sha256 "1b97998841305909638008bd9fa3fca597907cb23830046fd2e610632cdabba3"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    sha256 cellar: :any_skip_relocation, mojave: "21e7a8e4526065b0b4b4b8b754dee9d60cb41127f5e3dad2c602841af88befde"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
