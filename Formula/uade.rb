class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.01.tar.bz2"
    sha256 "a669c215970db2595027c16ee01149613fcfa4b81be67216ce6d7add871ef62a"

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", revision: "5a1ccf65393ee50af3a029d0632f29567467873c"
    end
  end

  livecheck do
    url "https://zakalwe.fi/uade/download.html"
    regex(/href=.*?uade[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uade"
    sha256 mojave: "2d7789e3db4baae5501fa2e953aa629609b1ca80ba92dbfff363584093511654"
  end

  head do
    url "https://gitlab.com/uade-music-player/uade.git", branch: "master"

    resource "bencode-tools" do
      url "https://gitlab.com/heikkiorsila/bencodetools.git", branch: "master"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "libao"

  def install
    resource("bencode-tools").stage do
      system "./configure", "--prefix=#{prefix}", "--without-python"
      system "make"
      system "make", "install"
    end

    system "./configure", "--prefix=#{prefix}",
           "--without-write-audio"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/uade123 --get-info #{test_fixtures("test.mp3")} 2>&1", 1).chomp
    assert_equal "Unknown format: #{test_fixtures("test.mp3")}", output
  end
end
