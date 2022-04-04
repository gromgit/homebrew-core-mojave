class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.29/libgphoto2-2.5.29.tar.bz2"
  sha256 "dbe3cefad8c634fc134d93467a33e242cb1030f0b9829deb9f1703f368ac027e"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libgphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgphoto2"
    sha256 mojave: "a36f6406af67994d462676f4d82a9e848724ffc88b9d1fa4eb6cf3142074dcdf"
  end

  head do
    url "https://github.com/gphoto/libgphoto2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "autoreconf", "-fvi" if build.head?
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
