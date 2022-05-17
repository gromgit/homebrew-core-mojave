class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/26/40/20891ed2770311c22543499a011906858bb12450bf46bd6d763f39da0002/asciinema-2.2.0.tar.gz"
  sha256 "5ec5c4e5d3174bb7c559e45db4680eb8fa6c40c058fa5e5005ee96a1d99737b4"
  license "GPL-3.0"
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/asciinema"
    sha256 cellar: :any_skip_relocation, mojave: "078f0815ed94fb3829dca824dd3ea0741e7ccdd72448d530da3b43fe3839006c"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end
