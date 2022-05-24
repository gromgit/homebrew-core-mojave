class Ykdl < Formula
  include Language::Python::Virtualenv

  desc "Video downloader that focus on China mainland video sites"
  homepage "https://github.com/SeaHOH/ykdl"
  url "https://files.pythonhosted.org/packages/1e/a2/8d68c0f5bfda82033fac0d36875c185241de37e1ac56f8b3f161e825a1e6/ykdl-1.8.1.post1.tar.gz"
  sha256 "97b179ef7059685fbbb24d4f50ae6e5e01f08e9c0998b292dc1ca44c1af09dc1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ykdl"
    sha256 cellar: :any_skip_relocation, mojave: "758cea0b6211bbd3c9f2627b23a8e86be46a367c332b5625ea44d01996597daa"
  end

  depends_on "python@3.10"

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/28/97/d2d3d96952c77e7593e0f4a634656fb384f7282327f7fef74b726b3b4c1c/iso8601-1.0.2.tar.gz"
    sha256 "27f503220e6845d9db954fb212b95b0362d8b7e6c1b2326a87061c3de93594b1"
  end

  resource "jsengine" do
    url "https://files.pythonhosted.org/packages/1c/1c/899994765c0395caec18b3e5381e61bac256c35a43f80fb468f3de689f95/jsengine-1.0.5.tar.gz"
    sha256 "f9676bad44904483f0b17bf2838b07893c9fbaf575f2153e46735b767243199f"
  end

  resource "m3u8" do
    url "https://files.pythonhosted.org/packages/0a/c1/ea98c5f109be04a745d01437f77b801192f3cf56cb834fa5e660f0a0ce03/m3u8-2.0.0.tar.gz"
    sha256 "bd8727a74c23fd706f2dc2a53f319391589ea64bb3a5c76b1c9b5707d8f4a0b0"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    "To merge video slides, run `brew install ffmpeg`."
  end

  test do
    system bin/"ykdl", "--info", "https://v.youku.com/v_show/id_XNTAzNDM5NTQ5Mg==.html"
  end
end
