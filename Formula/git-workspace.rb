class GitWorkspace < Formula
  desc "Sync personal and work git repositories from multiple providers"
  homepage "https://github.com/orf/git-workspace"
  url "https://github.com/orf/git-workspace/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "59876001a048eb46cffe67ad8801d13b3cfc5b36c708e88eb947ebef8f3b8bf1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-workspace"
    sha256 cellar: :any_skip_relocation, mojave: "92268c9766eb988070b224440ba93f34f42dbe93ab10bdca00ef48e0bc81a939"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["GIT_WORKSPACE"] = Pathname.pwd
    ENV["GITHUB_TOKEN"] = "foo"
    system "#{bin}/git-workspace", "add", "github", "foo"
    assert_match "provider = \"github\"", File.read("workspace.toml")
    output = shell_output("#{bin}/git-workspace update 2>&1", 1)
    assert_match "Error fetching repositories from Github user/org foo", output
  end
end
