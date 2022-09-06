class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.14.0.tar.gz"
  sha256 "7d1ab2949d00f712ad16c8c7fc4be500d20def9ba70394182720a36d300a967c"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    sha256 cellar: :any_skip_relocation, mojave: "07ebbfce2c4f65d63d35f3baab30926440c09209e16803b55ea0d2bf31beb607"
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
