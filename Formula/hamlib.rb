class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-4.4.tar.gz"
  sha256 "8bf0107b071f52f08587f38e2dee8a7848de1343435b326f8f66d95e1f8a2487"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hamlib"
    sha256 cellar: :any, mojave: "596aa890f66b90beda5ca6d7576e09fa9150698d14a39ed89e8d834e1d4e8530"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  on_linux do
    depends_on "gcc"
  end

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
