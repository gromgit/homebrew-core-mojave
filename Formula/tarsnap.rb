class Tarsnap < Formula
  desc "Online backups for the truly paranoid"
  homepage "https://www.tarsnap.com/"
  url "https://www.tarsnap.com/download/tarsnap-autoconf-1.0.40.tgz"
  sha256 "bccae5380c1c1d6be25dccfb7c2eaa8364ba3401aafaee61e3c5574203c27fd5"
  license "0BSD"

  livecheck do
    url "https://www.tarsnap.com/download.html"
    regex(/href=.*?tarsnap-autoconf[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tarsnap"
    rebuild 1
    sha256 cellar: :any, mojave: "d2faa7f2e46ee37d8a06c509a262a5e5789aebaac475885c65060931246c5e05"
  end

  head do
    url "https://github.com/Tarsnap/tarsnap.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "e2fsprogs" => :build
  end

  def install
    # dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    # Reported 20 Aug 2017 https://github.com/Tarsnap/tarsnap/issues/286
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "libcperciva/util/monoclock.c", "CLOCK_MONOTONIC",
                                                "UNDEFINED_GIBBERISH"
    end

    system "autoreconf", "-iv" if build.head?

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bash-completion-dir=#{bash_completion}
      --without-lzma
      --without-lzmadec
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"tarsnap", "-c", "--dry-run", testpath
  end
end
