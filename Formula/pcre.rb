class Pcre < Formula
  desc "Perl compatible regular expressions library"
  homepage "https://www.pcre.org/"
  license "BSD-3-Clause"

  stable do
    url "https://downloads.sourceforge.net/project/pcre/pcre/8.45/pcre-8.45.tar.bz2"
    mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre-8.45.tar.bz2"
    sha256 "4dae6fdcd2bb0bb6c37b5f97c33c2be954da743985369cddac3546e3218bffb8"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # From the PCRE homepage:
  # "The older, but still widely deployed PCRE library, originally released in
  # 1997, is at version 8.45. This version of PCRE is now at end of life, and
  # is no longer being actively maintained. Version 8.45 is expected to be the
  # final release of the older PCRE library, and new projects should use PCRE2
  # instead."
  livecheck do
    skip "PCRE was declared end of life in 2021-06"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pcre"
    rebuild 1
    sha256 cellar: :any, mojave: "4e1e66fc48e50588ea20f782986cc3bd0b0a6eece0eb582f0ae7767a7b884fba"
  end

  head do
    url "svn://vcs.exim.org/pcre/code/trunk"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-utf8
      --enable-pcre8
      --enable-pcre16
      --enable-pcre32
      --enable-unicode-properties
      --enable-pcregrep-libz
      --enable-pcregrep-libbz2
    ]

    # JIT not currently supported for Apple Silicon or OS older than sierra
    args << "--enable-jit" if MacOS.version >= :sierra && !Hardware::CPU.arm?

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "test"
    system "make", "install"
  end

  test do
    system "#{bin}/pcregrep", "regular expression", "#{prefix}/README"
  end
end
