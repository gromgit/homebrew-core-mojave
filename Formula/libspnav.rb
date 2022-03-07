class Libspnav < Formula
  desc "Client library for connecting to 3Dconnexion's 3D input devices"
  homepage "https://spacenav.sourceforge.io"
  url "https://downloads.sourceforge.net/project/spacenav/spacenav%20library%20%28SDK%29/libspnav%200.3/libspnav-0.3.tar.gz"
  sha256 "e1f855f47da6e75bdec81fe4b67171406abaf342c6fe3208c78e13bf862a3f05"

  livecheck do
    url :stable
    regex(%r{url=.*?/libspnav[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libspnav"
    rebuild 1
    sha256 cellar: :any, mojave: "d1c7568a9f0e63caabdcdc2e8a2265571516ade3c693b90fc03db7191530353b"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-x11
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <spnav.h>

      int main() {
        bool connected = spnav_open() != -1;
        if (connected) spnav_close();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}", "-L#{lib}", "-lspnav", "-o", "test"
    system "./test"
  end
end
