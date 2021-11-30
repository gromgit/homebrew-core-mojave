class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.10.2.tar.gz"
  sha256 "e0f71d72eca543478941401bd96fefc5fa3f70e7860a9f858f63bfecf8fd77a5"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "598bf9425bd404b8c76a3b681898d5b6cd645734060609799d27b17339f2d916"
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
