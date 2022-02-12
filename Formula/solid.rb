class Solid < Formula
  desc "Collision detection library for geometric objects in 3D space"
  homepage "https://github.com/dtecta/solid3/"
  url "https://github.com/dtecta/solid3/archive/ec3e218616749949487f81165f8b478b16bc7932.tar.gz"
  version "3.5.8"
  sha256 "e3a23751ebbad5e35f50e685061f1ab9e1bd3777317efc6912567f55259d0f15"
  license any_of: ["GPL-2.0-only", "QPL-1.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/solid"
    sha256 cellar: :any, mojave: "22f57d0cbea526cebb1bf6cd9da06c68163578ed8512dcb31963da14e4ec10b4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "texinfo" => :build

  # This patch fixes a broken build on clang-600.0.56.
  # Was reported to bugs@dtecta.com (since it also applies to solid-3.5.6)
  patch :DATA

  def install
    # Avoid `required file not found` errors
    touch ["AUTHORS", "ChangeLog", "NEWS"]

    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}"

    # Don't make examples, as they do not compile because the include
    # statements for the GLUT library are not platform independent
    inreplace "Makefile", /^(SUBDIRS *=.*) examples( .+)?/, '\1\2'

    system "make", "install"
  end
end

__END__
diff --git a/src/complex/DT_CBox.h b/src/complex/DT_CBox.h
index 7fc7c5d..16ce972 100644
--- a/src/complex/DT_CBox.h
+++ b/src/complex/DT_CBox.h
@@ -131,4 +131,6 @@ inline DT_CBox operator-(const DT_CBox& b1, const DT_CBox& b2)
                    b1.getExtent() + b2.getExtent());
 }

+inline DT_CBox computeCBox(MT_Scalar margin, const MT_Transform& xform);
+
 #endif
