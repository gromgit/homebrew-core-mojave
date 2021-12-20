class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.11.3.tar.gz"
  sha256 "cf68f43d4d26c10551c0137a7e718719958e52267d83f29a8f7794af12095b9e"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    sha256 cellar: :any_skip_relocation, mojave: "6b5e590caf8318423c85f745defb93fa0c333072d544acac518d5571c7708110"
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
