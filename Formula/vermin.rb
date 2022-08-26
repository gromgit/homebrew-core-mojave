class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://github.com/netromdk/vermin/archive/v1.4.2.tar.gz"
  sha256 "c9a69420b610bfb25d5a2abd7da6edf0ae4329481a857ef6c5d71f602ed5c63d"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vermin"
    sha256 cellar: :any_skip_relocation, mojave: "b3010a816194fab5d82a519b82855a5a99e161355483c98361fc27b9bddd9f21"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    path = libexec/Language::Python.site_packages("python3.10")/"vermin"
    assert_match "Minimum required versions: 2.7, 3.0", shell_output("#{bin}/vermin #{path}")
  end
end
