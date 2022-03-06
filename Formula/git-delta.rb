class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.12.0.tar.gz"
  sha256 "36ef6b05984e7c3b6e42aa35999c6c9ea1cd8c38c6ea940c03d3c9f25af12d6d"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9ae17d9a2f5986b342baadcadeeabe8a068be6f1fd4e089a7f2b30fc1079e47d"
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
