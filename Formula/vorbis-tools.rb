class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.2.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/vorbis/vorbis-tools-1.4.2.tar.gz"
  sha256 "db7774ec2bf2c939b139452183669be84fda5774d6400fc57fde37f77624f0b0"
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(/href=.*?vorbis-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vorbis-tools"
    sha256 cellar: :any, mojave: "eadca6683e6069e4044c9745107b794d58f773c90b98a0fbf7e2163c1ba409e7"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"

  uses_from_macos "curl"

  def install
    system "./configure", *std_configure_args, "--disable-nls"
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_predicate testpath/"test.ogg", :exist?
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end
