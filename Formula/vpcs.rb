class Vpcs < Formula
  desc "Virtual PC simulator for testing IP routing"
  homepage "https://vpcs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/vpcs/0.8/vpcs-0.8-src.tbz"
  sha256 "dca602d0571ba852c916632c4c0060aa9557dd744059c0f7368860cfa8b3c993"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vpcs"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "28ffdd64d74709c21da22c5913944f6c677a24b2b50a82d0220de53f1b16b323"
  end

  def install
    cd "src" do
      if OS.mac?
        system "make", "-f", "Makefile.osx"
      else
        system "make", "-f", "Makefile.linux"
      end
      bin.install "vpcs"
    end
  end

  test do
    system "#{bin}/vpcs", "--version"
  end
end
