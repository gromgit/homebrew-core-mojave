class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/f1/e9/3b6f38f800602f9724b3e5b1bf0350e397a0092a3f1fa698e0aeb173122f/you-get-0.4.1555.tar.gz"
  sha256 "99282aca720c7ee1d9ef4b63bbbd226e906ea170b789a459fafd5b0627b0b15f"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/you-get"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "5107ca06d1be4130ed110719c82e778360898033a8746ee458badb7edfef9b97"
  end

  depends_on "python@3.10"
  depends_on "rtmpdump"

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To use post-processing options, run `brew install ffmpeg` or `brew install libav`."
  end

  test do
    system bin/"you-get", "--info", "https://youtu.be/he2a4xK8ctk"
  end
end
