class GitCinnabar < Formula
  desc "Git remote helper to interact with mercurial repositories"
  homepage "https://github.com/glandium/git-cinnabar"
  url "https://github.com/glandium/git-cinnabar/archive/0.5.8.tar.gz"
  sha256 "7971c2ae17d2b919f915efab35e3aba583b951d53ca2bc6ebf69bbd0c22f1067"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/glandium/git-cinnabar.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-cinnabar"
    sha256 cellar: :any_skip_relocation, mojave: "1570bdcce06547e5120a47481d0b781c6b9fd95bee8ea15fbf3547d0088e50de"
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
