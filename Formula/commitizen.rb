class Commitizen < Formula
  include Language::Python::Virtualenv

  desc "Defines a standard way of committing rules and communicating it"
  homepage "https://commitizen-tools.github.io/commitizen/"
  url "https://files.pythonhosted.org/packages/c0/6e/6d70a43139f506a4d53e6596ca786008cfb7e19e2e7add167d04ef8947ca/commitizen-2.21.2.tar.gz"
  sha256 "64fda8d9d679d2d3d2422c028cb641602fb672560a5485bee9773259f9c4f07c"
  license "MIT"
  head "https://github.com/commitizen-tools/commitizen.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/commitizen"
    sha256 cellar: :any_skip_relocation, mojave: "fc63c30d64b4e328aeca7642220392a306f19b554e917b2c129cc5284ddec8cb"
  end

  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "decli" do
    url "https://files.pythonhosted.org/packages/9f/30/064f53ca7b75c33a892dcc4230f78a1e01bee4b5b9b49c0be1a61601c9bd/decli-0.5.2.tar.gz"
    sha256 "f2cde55034a75c819c630c7655a844c612f2598c42c21299160465df6ad463ad"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/91/a5/429efc6246119e1e3fbf562c00187d04e83e54619249eb732bb423efa6c6/Jinja2-3.0.3.tar.gz"
    sha256 "611bb273cd68f3b993fabdc4064fc858c5b47a973cb5aa7999ec1ba405c87cd7"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/62/0f/52c009332fdadd484e898dc8f2acca0663c1031b3517070fd34ad9c1b64e/MarkupSafe-2.1.0.tar.gz"
    sha256 "80beaf63ddfbc64a0452b841d8036ca0611e049650e20afcb882f5d3c266d65f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/37/34/c34c376882305c5051ed7f086daf07e68563d284015839bfb74d6e61d402/prompt_toolkit-3.0.28.tar.gz"
    sha256 "9f1cd16b1e86c2968f2519d7fb31dd9d669916f515612c269d14e9ed52b51650"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/04/c6/a8dbf1edcbc236d93348f6e7c437cf09c7356dd27119fcc3be9d70c93bb1/questionary-1.10.0.tar.gz"
    sha256 "600d3aefecce26d48d97eee936fdb66e4bc27f934c3ab6dd1e292c4f43946d90"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/c7/f0/cc387a2ff7da8f9450d6af4c108bed1f9b7289695330b6b5f412ebc8d6aa/tomlkit-0.10.0.tar.gz"
    sha256 "d99946c6aed3387c98b89d91fb9edff8f901bf9255901081266a84fb5604adcd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/b1/5a/8b5fbb891ef3f81fc923bf3cb4a578c0abf9471eb50ce0f51c74212182ab/typing_extensions-4.1.1.tar.gz"
    sha256 "1a9462dcc3347a79b1f1c0271fbe79e844580bb598bafa1ed208b94da3cdcd42"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Generates a changelog after an example commit
    system "git", "init"
    touch "example"
    system "git", "add", "example"
    system "yes | #{bin}/cz commit"
    system "#{bin}/cz", "changelog"

    # Verifies the checksum of the changelog
    expected_sha = "97da642d3cb254dbfea23a9405fb2b214f7788c8ef0c987bc0cde83cca46f075"
    output = File.read(testpath/"CHANGELOG.md")
    assert_match Digest::SHA256.hexdigest(output), expected_sha
  end
end
