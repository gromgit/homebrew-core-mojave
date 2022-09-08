class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v2.1.1.tar.gz"
  sha256 "29627520c81101de01b0213434adb218a9f1210bfd3f2dcfdfc1f975dbce6399"
  license "Apache-2.0"
  revision 2
  head "https://github.com/zmap/zmap.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zmap"
    rebuild 2
    sha256 mojave: "520df29fbf3280d598de39587adaf4c4fbe2db86992c95b0a9a3d474228c91e1"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "libdnet"

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  # fix json-c 0.14 compat
  # ref PR, https://github.com/zmap/zmap/pull/609
  patch :DATA

  def install
    inreplace ["conf/zmap.conf", "src/zmap.c", "src/zopt.ggo.in"], "/etc", etc

    system "cmake", ".", *std_cmake_args, "-DENABLE_DEVELOPMENT=OFF",
                         "-DRESPECT_INSTALL_PREFIX_CONFIG=ON"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/zmap", "--version"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 8bd825f..c70b651 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -72,6 +72,7 @@
     endif()

     add_definitions("-DJSON")
+    string(REPLACE ";" " " JSON_CFLAGS "${JSON_CFLAGS}")
     set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${JSON_CFLAGS}")
 endif()
