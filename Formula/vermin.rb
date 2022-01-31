class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.3.3.tar.gz"
  sha256 "35cd8bc3f54f651dbb162a7b35b4b091409154ce6d565df043f7f04bf9401d7d"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vermin"
    sha256 cellar: :any_skip_relocation, mojave: "4a31f6d451c7be3fca256f08212b838d348ca520c07e64c6921834fc4409f154"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/"lib/python3.10/site-packages/vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin -q #{path}")
  end
end
