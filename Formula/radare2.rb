class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.7.8.tar.gz"
  sha256 "084f262873f7ebbb54cfe01ebf14b43136e5a7442df8ecf01b37e7060a49b432"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/radare2"
    rebuild 1
    sha256 mojave: "33b613376c10b39e9670ab91f4d54da3acf8f4ce368cdb3c74b885f2716fb830"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end
