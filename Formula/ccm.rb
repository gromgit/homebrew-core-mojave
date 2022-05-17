class Ccm < Formula
  include Language::Python::Virtualenv

  desc "Create and destroy an Apache Cassandra cluster on localhost"
  homepage "https://github.com/riptano/ccm"
  url "https://files.pythonhosted.org/packages/f1/12/091e82033d53b3802e1ead6b16045c5ecfb03374f8586a4ae4673a914c1a/ccm-3.1.5.tar.gz"
  sha256 "f07cc0a37116d2ce1b96c0d467f792668aa25835c73beb61639fa50a1954326c"
  license "Apache-2.0"
  revision 3
  head "https://github.com/riptano/ccm.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ccm"
    sha256 cellar: :any_skip_relocation, mojave: "b56465bcd079fcbaecd969d8c98f271d0e2b7b58b21afa89394ad04fb4a87014"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "cassandra-driver" do
    url "https://files.pythonhosted.org/packages/19/bd/b522b200e8a7cc5ace859e9667308a3a302a23d6df09ae087ca2dfbf60c2/cassandra-driver-3.22.0.tar.gz"
    sha256 "df825ee4ebb7f7fa33ab028d673530184fe0ee41ea66b2f9ddd478db56145a31"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage", shell_output("#{bin}/ccm", 1)
  end
end
