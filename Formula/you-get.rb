class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/c9/87/0ad2082c87762cb7dee763f2982c02f659197b28417577191873054add20/you-get-0.4.1612.tar.gz"
  sha256 "94a133b70c27d699c02eec03880d4893df97095c8ef943286effa15eed269f9c"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/you-get"
    sha256 cellar: :any_skip_relocation, mojave: "69bd3721351cfd339187988f5c3a8166669036d157e3f8da86667d022fc0b231"
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
