class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/ba/16/9c3660c4244915284cd7ce1f7ba3304cec29bdf3ef875279b3166630f6be/you-get-0.4.1620.tar.gz"
  sha256 "c020da4fd373d59892b2a1705f53d71eae9017a7e32d123dc30bef5b172660e6"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/you-get"
    sha256 cellar: :any_skip_relocation, mojave: "3d665a6eb3292501d2bd2994b0718088799956dad03aa1ed69535688745a95a5"
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
