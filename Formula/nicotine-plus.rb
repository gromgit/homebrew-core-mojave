class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/fa/85/cb0ecfce7b529446104cb29a7bfe78a2d0efa124444fbc591c6a5193a824/nicotine-plus-3.2.1.tar.gz"
  sha256 "a2835bdce9054afc727e554e02585d34f153ba1d5fae9f883758212b089a8539"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nicotine-plus"
    sha256 cellar: :any_skip_relocation, mojave: "aaa6ec5dd1bd8bf311e0bd028e5cd257d8b80ec4eeef1a07481c9190fe7a928e"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end
