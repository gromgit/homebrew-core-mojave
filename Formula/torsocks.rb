class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitlab.torproject.org/tpo/core/torsocks"
  url "https://gitlab.torproject.org/tpo/core/torsocks/-/archive/v2.4.0/torsocks-v2.4.0.tar.bz2"
  sha256 "54b2e3255b697fb69bb92388376419bcef1f94d511da3980f9ed5cd8a41df3a8"
  head "https://gitlab.torproject.org/tpo/core/torsocks.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/torsocks"
    sha256 mojave: "841a154a85f78d90f1ed8ac0e893e14709800bb0e43718f0903a12fb10054c0c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # https://gitlab.torproject.org/legacy/trac/-/issues/28538
  patch do
    url "https://gitlab.torproject.org/legacy/trac/uploads/9efc1c0c47b3950aa91e886b01f7e87d/0001-Fix-macros-for-accept4-2.patch"
    sha256 "97881f0b59b3512acc4acb58a0d6dfc840d7633ead2f400fad70dda9b2ba30b0"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/torsocks", "--help"
  end
end
