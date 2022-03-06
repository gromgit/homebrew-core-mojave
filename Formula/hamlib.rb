class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.4/hamlib-4.4.tar.gz"
  sha256 "8bf0107b071f52f08587f38e2dee8a7848de1343435b326f8f66d95e1f8a2487"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hamlib"
    rebuild 1
    sha256 cellar: :any, mojave: "49a14441b0de911b0f9f41b7007c11d5925f34692a64e72031872d51d1da72b6"
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
