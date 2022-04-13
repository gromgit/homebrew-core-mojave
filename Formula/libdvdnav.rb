class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://www.videolan.org/developers/libdvdnav.html"
  license "GPL-2.0-or-later"

  stable do
    url "https://download.videolan.org/pub/videolan/libdvdnav/6.1.1/libdvdnav-6.1.1.tar.bz2"
    sha256 "c191a7475947d323ff7680cf92c0fb1be8237701885f37656c64d04e98d18d48"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://download.videolan.org/pub/videolan/libdvdnav/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libdvdnav"
    rebuild 1
    sha256 cellar: :any, mojave: "bc011a1f12d16df22a9168aaf8567bdf14a53ecf3e2a1e4075e21f7753bde77a"
  end

  head do
    url "https://code.videolan.org/videolan/libdvdnav.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
