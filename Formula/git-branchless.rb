class GitBranchless < Formula
  desc "High-velocity, monorepo-scale workflow for Git"
  homepage "https://github.com/arxanas/git-branchless"
  url "https://github.com/arxanas/git-branchless/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "eb785437ec9968b3f70472db16cf61658b5105da5fb541991546ac3ad32548af"
  license "GPL-2.0-only"
  head "https://github.com/arxanas/git-branchless.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-branchless"
    sha256 cellar: :any, mojave: "5ccc517fd8e7a5b6b27be30ab9dae7aeee2848d097ce5251db9c3a7b13c0ebfc"
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"

    system "git", "branchless", "init"
    assert_match "Initial Commit", shell_output("git sl").strip
  end
end
