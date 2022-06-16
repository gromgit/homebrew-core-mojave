class Uade < Formula
  desc "Play Amiga tunes through UAE emulation"
  homepage "https://zakalwe.fi/uade/"
  license "GPL-2.0-only"

  stable do
    url "https://zakalwe.fi/uade/uade3/uade-3.02.tar.bz2"
    sha256 "2aa317525402e479ae8863222e3c341d135670fcb23a2853ac93075ac428f35b"

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
    sha256 mojave: "55e48919392b47c81568c647fc2b0dd1fbb5b75471d598807307e849a9c97458"
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
