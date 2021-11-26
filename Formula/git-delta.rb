class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.10.0.tar.gz"
  sha256 "ce326c6010732734055671fd85733e0c19c5dff9401485bbf8d57024c6fa99da"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-delta"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "bbe7ace3d9abb5c1196c0c8ba6a62e3f246b01ced29fd24c7816b53c070abcd1"
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
