class Vttest < Formula
  desc "Test compatibility of VT100-compatible terminals"
  homepage "https://invisible-island.net/vttest/"
  url "https://invisible-mirror.net/archives/vttest/vttest-20220827.tgz", using: :homebrew_curl
  sha256 "5726aae58137773ce6ce01fe6a86fc0f83c47763e30488bff35b9bc4fc946ce2"
  license "BSD-3-Clause"

  livecheck do
    url "https://invisible-mirror.net/archives/vttest/"
    regex(/href=.*?vttest[._-]v?(\d+(?:[.-]\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vttest"
    sha256 cellar: :any_skip_relocation, mojave: "474cc0e476162db1cee73f339fdf6c21dc2f66b16870dcd10bc63487609fcd65"
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
