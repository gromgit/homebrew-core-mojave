class GitTrim < Formula
  desc "Trim your git remote tracking branches that are merged or gone"
  homepage "https://github.com/foriequal0/git-trim"
  url "https://github.com/foriequal0/git-trim/archive/v0.4.2.tar.gz"
  sha256 "0f728c7f49cc8ffb0c485547a114c94bdebd7eead9466b1b43f486ef583a3d73"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-trim"
    rebuild 1
    sha256 cellar: :any, mojave: "c9f7fb54a11ef6a556385016aba68344e76b1e1c04f7f12c3911815c2b123cda"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  # Patch for OpenSSL 3 compatibility
  # Upstream PR ref, https://github.com/foriequal0/git-trim/pull/195
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/a67e684/git-trim/openssl-3.diff"
    sha256 "b54a6ae417e520aefa402155acda892c40c23183a325cf37ac70920b5ad0246c"
  end

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "docs/git-trim.man" => "git-trim.1"
  end

  test do
    system "git", "clone", "https://github.com/foriequal0/git-trim"
    Dir.chdir("git-trim")
    system "git", "branch", "brew-test"
    assert_match "brew-test", shell_output("git trim")
  end
end
