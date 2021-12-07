class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.34.1.tar.xz"
  sha256 "3a0755dd1cfab71a24dd96df3498c29cd0acd13b04f3d08bf933e81286db802c"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-credential-libsecret"
    rebuild 2
    sha256 cellar: :any, mojave: "dde8fcd39fbf53e258a13d2985be5d228b50505d1363f25fa7edf562f985fa0c"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
