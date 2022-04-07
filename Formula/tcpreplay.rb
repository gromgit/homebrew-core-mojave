class Tcpreplay < Formula
  desc "Replay saved tcpdump files at arbitrary speeds"
  homepage "https://tcpreplay.appneta.com/"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.4.1/tcpreplay-4.4.1.tar.gz"
  sha256 "cb67b6491a618867fc4f9848f586019f1bb2ebd149f393afac5544ee55e4544f"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "BSD-4-Clause", "GPL-3.0-or-later", "ISC"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tcpreplay"
    rebuild 1
    sha256 cellar: :any, mojave: "4b5bfb8967bfd15e0eaf4a54e2401ac2d481526461ff005ae54d741e32b23750"
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

    system "./autogen.sh"
    system "./configure", *args

    system "make", "install"
  end

  test do
    system bin/"tcpreplay", "--version"
  end
end
