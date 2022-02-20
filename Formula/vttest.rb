class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20220215.tgz", using: :homebrew_curl
  sha256 "4a65998c5e12cf08ced2cfce119adb44fa842ac1495d0f150f21c8a6785915a1"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vttest"
    sha256 cellar: :any_skip_relocation, mojave: "9b1e08a64bf323c4532f6ed294acdcb31c32f2adacdc8d18beaa562b972eb27b"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output(bin/"vttest -V")
  end
end
