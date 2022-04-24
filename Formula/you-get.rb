class YouGet < Formula
  include Language::Python::Virtualenv

  desc "Dumb downloader that scrapes the web"
  homepage "https://you-get.org/"
  url "https://files.pythonhosted.org/packages/6d/f1/4f76c9fcd58cce3619196d67b3f11a996da7610f34d73538b6c8af8f6353/you-get-0.4.1602.tar.gz"
  sha256 "4706c06cc4b9080ea93b4f13b9a4dbebb60cfe12d191c78e17b0fa895d17708f"
  license "MIT"
  head "https://github.com/soimort/you-get.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/you-get"
    sha256 cellar: :any_skip_relocation, mojave: "5eab149f5f6790038d34c8549ffaac5a165b745895c37c46f759e05390196566"
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
