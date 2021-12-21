class VpnSlice < Formula
  include Language::Python::Virtualenv

  desc "Vpnc-script replacement for easy and secure split-tunnel VPN setup"
  homepage "https://github.com/dlenski/vpn-slice"
  url "https://files.pythonhosted.org/packages/bc/79/49fc8347a51f70f4c5501f93809f4dc757729def77749cf16af6643074de/vpn-slice-0.16.tar.gz"
  sha256 "6d5c8d972126775181397dcc65332ec60c5b35fe1647b1022ace863589c59a12"
  license "GPL-3.0-or-later"
  head "https://github.com/dlenski/vpn-slice.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vpn-slice"
    sha256 cellar: :any_skip_relocation, mojave: "8a70757add36bae76c178f885634ce91180ae2b60ee7848ce794f77259e387ea"
  end

  depends_on "rust" => :build # for cryptography, can remove if dnspython has new release
  depends_on "python@3.10"

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/a1/7f/a1d4f4c7b66f0fc02f35dc5c85f45a8b4e4a7988357a29e61c14e725ef86/setproctitle-1.2.2.tar.gz"
    sha256 "7dfb472c8852403d34007e01d6e3c68c57eb66433fb8a5c77b13b89a160d97df"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # vpn-slice needs root/sudo credentials
    output = `#{bin}/vpn-slice 192.168.0.0/24 2>&1`
    assert_match "Cannot read\/write \/etc\/hosts", output
    assert_equal 1, $CHILD_STATUS.exitstatus
  end
end
