class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.4.1.tar.gz"
  sha256 "ee69d5e84f0d446e0d6574ec60c428798de6e6c8d055589f65ac02f074a7da25"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vermin"
    sha256 cellar: :any_skip_relocation, mojave: "e6342067906c2748f93a63baf1ecfbdd7f65a4140875f333ba456dcb03d19fad"
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
