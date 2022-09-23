class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.4.2/tcpreplay-4.4.2.tar.gz"
  sha256 "5b272cd83b67d6288a234ea15f89ecd93b4fadda65eddc44e7b5fcb2f395b615"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tcpreplay"
    sha256 cellar: :any, mojave: "af79b21f773b3ef48ea3be1aa5e99593e422b1a63aea671fc6b3b87977191344"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdnet"

  uses_from_macos "libpcap"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-link
      --with-libdnet=#{Formula["libdnet"].opt_prefix}
    ]

    args << if OS.mac?
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      "--with-macosx-sdk=#{MacOS.version}"
    else
      "--with-libpcap=#{Formula["libpcap"].opt_prefix}"
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
