class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.30/libgphoto2-2.5.30.tar.bz2"
  sha256 "ee61a1dac6ad5cf711d114e06b90a6d431961a6e7ec59f4b757a7cd77b1c0fb4"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgphoto2"
    sha256 mojave: "fe2bd4969eac9097c8117252756b2e6d8a72a753da2b923319c6fb0ec2bb08d7"
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libtool"
  depends_on "libusb-compat"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gphoto2/gphoto2-camera.h>
      int main(void) {
        Camera *camera;
        return gp_camera_new(&camera);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgphoto2", "-o", "test"
    system "./test"
  end
end
