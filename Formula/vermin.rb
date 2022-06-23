class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.4.0.tar.gz"
  sha256 "984773ed6af60329e700b39c58b7584032acbc908a00b5a76d1ce5468c825c70"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vermin"
    sha256 cellar: :any_skip_relocation, mojave: "b161ec94326e573a7b96c5cc887ea932d17a1b4b3a501ba9f0522873ac997903"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/"lib/python3.10/site-packages/vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin #{path}")
  end
end
