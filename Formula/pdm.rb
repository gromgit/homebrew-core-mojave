class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/56/ae/223418072f8562a84ba6c873909910531d08d77fc13803451d4e3a394ed0/pdm-1.12.7.tar.gz"
  sha256 "efedebb9b006eb07a8800a6afe0989cea4254e9a0ccd9fdbb41ab744a34f3484"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pdm"
    sha256 cellar: :any_skip_relocation, mojave: "5e5740f64902419ffe16088395ed063afd5545e997debe4b73b69d17823b3474"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/d7/77/ebb15fc26d0f815839ecd897b919ed6d85c050feeb83e100e020df9153d2/attrs-21.4.0.tar.gz"
    sha256 "626ba8234211db98e869df76230a137c4c40a12d72445c45d5f5b716f076e2fd"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/1b/51/e2a9f3b757eb802f61dc1f2b09c8c99f6eb01cf06416c0671253536517b6/blinker-1.4.tar.gz"
    sha256 "471aee25f3992bd325afa3772f1063dbdbbca947a041b8b89466dc00d606f8b6"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "installer" do
    url "https://files.pythonhosted.org/packages/3c/b2/43a6ba5ca6d387adbb63a947a6123324e6f4a91932e0b2b739c3b8417610/installer-0.3.0.tar.gz"
    sha256 "e7dc5ec8b737fe3fa7c1872a6ebe120d7abc7cf780aa39af669c382a0fcb6de7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/78/b0/797847bec485f269e12780839d73a4f60cf8c85ffda32f4f1d092ff8d64d/pdm-pep517-0.10.2.tar.gz"
    sha256 "83bb71a7588df69ea0d77dc6524741c3a1af54ad5f421341428de648bfc03a29"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0a/65/6e656d49c679136edfba25f25791f45ffe1ea4ae2ec1c59fe9c35e061cd1/pep517-0.12.0.tar.gz"
    sha256 "931378d93d11b298cf511dd634cf5ea4cb249a28ef84160b3247ee9afb4e8ab0"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/be/00/bd080024010e1652de653bd61181e2dfdbef5fa73bfd32fec4c808991c31/platformdirs-2.4.1.tar.gz"
    sha256 "440633ddfebcc36264232365d7840a970e75e1018d15b4327d11f91909045fda"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/49/62/4f25667e10561303a34cb89e3187c35985c0889b99f6f1468aaf17fbb03e/python-dotenv-0.19.2.tar.gz"
    sha256 "a5de49a31e953b45ff2d2fd434bbc2670e8db5273606c1e737cc6b93eff3655f"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/e5/47/86274134782f8a3aec25a5d27d12243ed5f21e788f0bc3cab597ec170000/pythonfinder-1.2.9.tar.gz"
    sha256 "1a7f756c7f1b47558c9287bce87298c33760ded4552f06b82c28f3f0eee7b91f"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/3d/6e/d290c9bf16159f02b70c432386aa5bfe22c2857ff460591912fd907b61f6/tomli-2.0.0.tar.gz"
    sha256 "c292c34f58502a1eb2bbb9f5bbc9a5ebc37bee10ffb8c2d6bbdfa8eb13cc14e1"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0f/96/ee6ba35c61186fbf084cb3077374d50eef36ab59cb8c6513317caa190935/tomlkit-0.8.0.tar.gz"
    sha256 "29e84a855712dfe0e88a48f6d05c21118dbafb283bb2eed614d46f80deb8e9a1"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c0/6c/9f840c2e55b67b90745af06a540964b73589256cb10cc10057c87ac78fc2/wheel-0.37.1.tar.gz"
    sha256 "e9a504e793efbca1b8e0e9cb979a249cf4a0a7b5b8c9e8b65a5e39d49529c1c4"
  end

  def install
    virtualenv_install_with_resources
    (bash_completion/"pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "bash")
    (zsh_completion/"_pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "zsh")
    (fish_completion/"pdm.fish").write Utils.safe_popen_read("#{bin}/pdm", "completion", "fish")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"

    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
