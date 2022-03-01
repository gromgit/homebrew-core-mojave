class Dcadec < Formula
  desc "DTS Coherent Acoustics decoder with support for HD extensions"
  homepage "https://github.com/foo86/dcadec"
  url "https://github.com/foo86/dcadec.git",
      tag:      "v0.2.0",
      revision: "0e074384c9569e921f8facfe3863912cdb400596"
  license "LGPL-2.1"
  head "https://github.com/foo86/dcadec.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dcadec"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "610aa39428d51439683037afe4b68d29c73477dbacd2f127c6e3495e407cf65e"
  end


  resource "sample" do
    url "https://github.com/foo86/dcadec-samples/raw/fa7dcf8c98c6d/xll_71_24_96_768.dtshd"
    sha256 "d2911b34183f7379359cf914ee93228796894e0b0f0055e6ee5baefa4fd6a923"
  end

  def install
    system "make", "all"
    system "make", "check"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    resource("sample").stage do
      system "#{bin}/dcadec", resource("sample").cached_download
    end
  end
end
