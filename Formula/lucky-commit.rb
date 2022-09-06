class LuckyCommit < Formula
  desc "Customize your git commit hashes!"
  homepage "https://github.com/not-an-aardvark/lucky-commit"
  url "https://github.com/not-an-aardvark/lucky-commit/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "3b35472c90d36f8276bddab3e75713e4dcd99c2a7abc3e412a9acd52e0fbcf81"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lucky-commit"
    sha256 cellar: :any_skip_relocation, mojave: "c0aee7c89855142ef2e01554763bd8c035798845354203c747ab66782213a791"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "ocl-icd"
    depends_on "pocl"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    touch "foo"
    system "git", "add", "foo"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    system "git", "commit", "-m", "Initial commit"
    system bin/"lucky_commit", "1010101"
    assert_equal "1010101", Utils.git_short_head
  end
end
