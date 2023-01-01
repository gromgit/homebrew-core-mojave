class Devil < Formula
  desc "Cross-platform image library"
  homepage "https://sourceforge.net/projects/openil/"
  license "LGPL-2.1-only"
  revision 5
  head "https://github.com/DentonW/DevIL.git", branch: "master"

  stable do
    url "https://downloads.sourceforge.net/project/openil/DevIL/1.8.0/DevIL-1.8.0.tar.gz"
    sha256 "0075973ee7dd89f0507873e2580ac78336452d29d34a07134b208f44e2feb709"

    # jpeg 9 compatibility
    # Upstream commit from 3 Jan 2017 "Fixed int to boolean conversion error
    # under Linux"
    patch do
      url "https://github.com/DentonW/DevIL/commit/41fcabbe.patch?full_index=1"
      sha256 "324dc09896164bef75bb82b37981cc30dfecf4f1c2386c695bb7e92a2bb8154d"
    end

    # jpeg 9 compatibility
    # Upstream commit from 7 Jan 2017 "Fixing boolean compilation errors under
    # Linux / MacOS, issue #48 at https://github.com/DentonW/DevIL/issues/48"
    patch do
      url "https://github.com/DentonW/DevIL/commit/4a2d7822.patch?full_index=1"
      sha256 "7e74a4366ef485beea1c4285f2b371b6bfa0e2513b83d4d45e4e120690c93f1d"
    end

    # allow compiling against jasper >= 2.0.17
    patch do
      url "https://github.com/DentonW/DevIL/commit/42a62648.patch?full_index=1"
      sha256 "b3a99c34cd7f9a5681f43dc0886fe360ba7d1df2dd1eddd7fcdcae7898f7a68e"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/devil"
    sha256 cellar: :any, mojave: "f8b68699bddee4887a1e33f12e3bf37229890bb08e4aeeec4edae4d7a4fef19a"
  end

  depends_on "cmake" => :build
  depends_on "jasper"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  # allow compiling against jasper >= 3.0.0
  patch :DATA

  def install
    system "cmake", "-S", "DevIL", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <IL/il.h>
      int main() {
        ilInit();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lIL", "-lILU"
    system "./test"
  end
end

__END__
diff --git a/DevIL/src-IL/src/il_jp2.cpp b/DevIL/src-IL/src/il_jp2.cpp
index 89075a52..f46028a9 100644
--- a/DevIL/src-IL/src/il_jp2.cpp
+++ b/DevIL/src-IL/src/il_jp2.cpp
@@ -323,7 +323,9 @@ ILboolean iLoadJp2Internal(jas_stream_t	*Stream, ILimage *Image)
 //
 // see: https://github.com/OSGeo/gdal/commit/9ef8e16e27c5fc4c491debe50bf2b7f3e94ed334
 //      https://github.com/DentonW/DevIL/issues/90
-#if defined(PRIjas_seqent)
+#if JAS_VERSION_MAJOR >= 3
+static ssize_t iJp2_file_read(jas_stream_obj_t *obj, char *buf, size_t cnt)
+#elif defined(PRIjas_seqent)
 static int iJp2_file_read(jas_stream_obj_t *obj, char *buf, unsigned cnt)
 #else
 static int iJp2_file_read(jas_stream_obj_t *obj, char *buf, int cnt)
@@ -333,7 +335,9 @@ static int iJp2_file_read(jas_stream_obj_t *obj, char *buf, int cnt)
 	return iread(buf, 1, cnt);
 }

-#if defined(JAS_INCLUDE_JP2_CODEC)
+#if JAS_VERSION_MAJOR >= 3
+static ssize_t iJp2_file_write(jas_stream_obj_t *obj, const char *buf, size_t cnt)
+#elif defined(JAS_INCLUDE_JP2_CODEC)
 static int iJp2_file_write(jas_stream_obj_t *obj, const char *buf, unsigned cnt)
 #elif defined(PRIjas_seqent)
 static int iJp2_file_write(jas_stream_obj_t *obj, char *buf, unsigned cnt)
