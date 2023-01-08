class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.11.tar.gz"
  sha256 "20f94f6a9b05fff2684e8c5619a1a5703e7d472fd2d0e87b020b20b4190a6338"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-cinnabar"
    sha256 cellar: :any_skip_relocation, mojave: "5afbf52013b2edeac55407417649c2eadaa1539a0c3c7e58da139d1efb84f7df"
  end

  depends_on "mercurial"
  depends_on "python@3.11"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, PYTHONPATH:          prefix,
                                      GIT_CINNABAR_PYTHON: which("python3.11"))
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
