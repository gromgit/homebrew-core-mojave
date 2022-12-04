class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  license "BSD-3-Clause"

  stable do
    url "https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2", using: :homebrew_curl
    mirror "https://ftp.osuosl.org/pub/xiph/releases/theora/libtheora-1.1.1.tar.bz2"
    sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/theora/?C=M&O=D"
    regex(/href=.*?libtheora[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/theora"
    rebuild 5
    sha256 cellar: :any_skip_relocation, mojave: "cf210915141b6a29457a32bdbe5f7fb1b72884b810d0e7f25bbba68d62590cc5"
  end

  head do
    url "https://gitlab.xiph.org/xiph/theora.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-oggtest
      --disable-vorbistest
      --disable-examples
    ]

    args << "--disable-asm" if build.head?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <theora/theora.h>

      int main()
      {
          theora_info inf;
          theora_info_init(&inf);
          theora_info_clear(&inf);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltheora", "-o", "test"
    system "./test"
  end
end
