class GitGerrit < Formula
  desc "Gerrit code review helper scripts"
  homepage "https://github.com/fbzhong/git-gerrit"
  url "https://github.com/fbzhong/git-gerrit/archive/v0.3.0.tar.gz"
  sha256 "433185315db3367fef82a7332c335c1c5e0b05dabf8d4fbeff9ecf6cc7e422eb"
  license "BSD-3-Clause"
  head "https://github.com/fbzhong/git-gerrit.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-gerrit"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b31bb774c3609639c5b7c599aaea4da976dc12b930c842932cd253fd6f278e4d"
  end

  def install
    prefix.install "bin"
    bash_completion.install "completion/git-gerrit-completion.bash"
  end

  test do
    system "git", "init"
    system "git", "gerrit", "help"
  end
end
