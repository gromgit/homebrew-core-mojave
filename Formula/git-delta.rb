class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.10.1.tar.gz"
  sha256 "96feda5d979bdb2f3b747be1f6f05227e24ac20c0bfa95ead92f6a8b7de3b6a3"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4d29a06ed1f84dea8fbaf26915880affbe6876b12988214bb1f0eb72b480b522"
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
