class Reaver < Formula
  desc "Implements brute force attack to recover WPA/WPA2 passkeys"
  homepage "https://github.com/t6x/reaver-wps-fork-t6x"
  url "https://github.com/t6x/reaver-wps-fork-t6x/releases/download/v1.6.6/reaver-1.6.6.tar.xz"
  sha256 "e329a0da0b6dd888916046535ff86a6aa144644561937954e560bb1810ab6702"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/reaver"
    sha256 cellar: :any_skip_relocation, mojave: "1690251777ed56778c53aff5284b0d323e6ebb1746b2e242662fd23c812f28b8"
  end

  depends_on "pixiewps"

  uses_from_macos "libpcap"
  uses_from_macos "sqlite"

  def install
    # reported upstream in https://github.com/t6x/reaver-wps-fork-t6x/issues/195
    man1.install "docs/reaver.1"
    prefix.install_metafiles "docs"
    cd "src"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.mkpath
    system "make", "install"
  end
end
