class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.11.0.tar.gz"
  sha256 "55e6aa28869247a7fca7aa9229ea2ebeae75e79becb22988e645301778f7388b"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    sha256 cellar: :any_skip_relocation, mojave: "d36715584cee5102a8965b5b41f4713a12d202d1a36b6d6c3b1afc5fa6953f4d"
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
