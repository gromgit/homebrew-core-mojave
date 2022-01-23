class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/25/76/9ef26b9311b8a475d15a4173789a463fa9dc28cff0d11e9d3edd34da3889/nicotine-plus-3.2.0.tar.gz"
  sha256 "aca21de8596a81a54fdd306b5e1338fd530e94c983e01425dcaf48e6e1395785"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nicotine-plus"
    sha256 cellar: :any_skip_relocation, mojave: "4b536a3fa3cb7e58d6a16e7a54ab95487d6a3d4d7c34984ea90f8c723895d0e3"
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
