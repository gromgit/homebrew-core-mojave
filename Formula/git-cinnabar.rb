class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.9.tar.gz"
  sha256 "83374ff2c7e9ccbb5e866c6fb350ad3202cab4856841afbadaded1f1bef4d534"
  license "GPL-2.0-only"
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-cinnabar"
    sha256 cellar: :any_skip_relocation, mojave: "048ef97a25eb8dae8a8ea128eb0f458e289bb614fe22d6ed11750cc52f67a0bf"
  end

  depends_on "mercurial"
  depends_on "python@3.10"

  uses_from_macos "curl"

  conflicts_with "git-remote-hg", because: "both install `git-remote-hg` binaries"

  def install
    system "make", "helper"
    prefix.install "cinnabar"
    bin.install "git-cinnabar", "git-cinnabar-helper", "git-remote-hg"
    bin.env_script_all_files(libexec, PYTHONPATH:          prefix,
                                      GIT_CINNABAR_PYTHON: Formula["python@3.10"].opt_bin/"python3")
  end

  test do
    system "git", "clone", "hg::https://www.mercurial-scm.org/repo/hello"
    assert_predicate testpath/"hello/hello.c", :exist?,
                     "hello.c not found in cloned repo"
  end
end
