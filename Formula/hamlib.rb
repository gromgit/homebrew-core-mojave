class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.5.1/hamlib-4.5.1.tar.gz"
  sha256 "acdaf2f91c052e17276b06b9170a03f929600763caaf94a6377e1a906cd631c8"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hamlib"
    sha256 cellar: :any, mojave: "d52af9d6f0451c12b8261f218940b58d5665d7fcfeb9a81acfa37e8621a71565"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
