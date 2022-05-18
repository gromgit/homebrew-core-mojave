class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.36.1.tar.xz"
  sha256 "405d4a0ff6e818d1f12b3e92e1ac060f612adcb454f6299f70583058cb508370"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-credential-libsecret"
    sha256 cellar: :any, mojave: "620ea85befd1cc41c4db7dbc71743f6a2caf8b647b6a2fca203137eca27a1527"
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
