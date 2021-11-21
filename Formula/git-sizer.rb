class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.5.0.tar.gz"
  sha256 "07a5ac5f30401a17d164a6be8d52d3d474ee9c3fb7f60fd83a617af9f7e902bb"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-sizer"
    sha256 cellar: :any_skip_relocation, mojave: "f6f3ae4dada54a5c9ef663821996ee38c794b2bf246c8cb15d982e42bc263498"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.ReleaseVersion=#{version}")
  end

  test do
    system "git", "init"
    output = shell_output("#{bin}/git-sizer")
    assert_match "No problems above the current threshold were found", output
  end
end
