class Mdxmini < Formula
  desc "Plays music in X68000 MDX chiptune format"
  homepage "https://github.com/mistydemeo/mdxmini/"
  url "https://github.com/mistydemeo/mdxmini/archive/v2.0.0.tar.gz"
  sha256 "9b623b365e893a769084f7a2effedc9ece453c6e3861c571ba503f045471a0e0"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdxmini"
    sha256 cellar: :any, mojave: "2924bd60bd2a9cd8d29ac26f1eea538f29aa49ebd21d88dcd93e4a103bdad7ba"
  end

  depends_on "sdl2"

  resource "test_song" do
    url "https://ftp.modland.com/pub/modules/MDX/-%20unknown/Popful%20Mail/pop-00.mdx"
    sha256 "86f21fbbaf93eb60e79fa07c759b906a782afe4e1db5c7e77a1640e6bf63fd14"
  end

  # Fix build on Linux
  patch :DATA

  def install
    system "make", "CC=#{ENV.cc}", "LD=#{ENV.cc}"

    # Makefile doesn't build a dylib
    libmdxmini = shared_library("libmdxmini")

    flags = if OS.mac?
      %W[
        -dynamiclib
        -install_name #{lib/libmdxmini}
        -undefined dynamic_lookup
      ]
    else
      ["-shared"]
    end

    system ENV.cc, *flags, "-o", libmdxmini, *Dir["obj/*.o"]

    bin.install "mdxplay"
    lib.install libmdxmini
    (include/"libmdxmini").install Dir["src/*.h"]
  end

  test do
    resource("test_song").stage testpath
    (testpath/"mdxtest.c").write <<~EOS
      #include <stdio.h>
      #include "libmdxmini/mdxmini.h"

      int main(int argc, char** argv)
      {
          t_mdxmini mdx;
          char title[100];
          mdx_open(&mdx, argv[1], argv[2]);
          mdx_get_title(&mdx, title);
          printf("%s\\n", title);
      }
    EOS
    system ENV.cc, "mdxtest.c", "-L#{lib}", "-L#{Formula["sdl2"].opt_lib}", "-lmdxmini", "-lSDL2", "-o", "mdxtest"

    result = shell_output("#{testpath}/mdxtest #{testpath}/pop-00.mdx #{testpath}").chomp
    result.force_encoding("ascii-8bit") if result.respond_to? :force_encoding

    # Song title is in Shift-JIS
    # Trailing whitespace is intentional & shouldn't be removed.
    l1 = "\x82\xDB\x82\xC1\x82\xD5\x82\xE9\x83\x81\x83C\x83\x8B         "
    l2 = "\x83o\x83b\x83N\x83A\x83b\x83v\x8D\xEC\x90\xAC          "
    expected = <<~EOS
      #{l1}
      #{l2}
      (C)Falcom 1992 cv.\x82o\x82h. ass.\x82s\x82`\x82o\x81{
    EOS
    expected.force_encoding("ascii-8bit") if result.respond_to? :force_encoding
    assert_equal expected.delete!("\n"), result
  end
end

__END__
diff --git a/Makefile b/Makefile
index 9b63041..ff725c3 100644
--- a/Makefile
+++ b/Makefile
@@ -43,6 +43,7 @@ FILES_ORG = COPYING AUTHORS
 LIB = $(OBJDIR)/lib$(TITLE).a

 LIBS += $(LIB)
+LIBS += -lm

 ZIPSRC = $(TITLE)`date +"%y%m%d"`.zip
 TOUCH = touch -t `date +"%m%d0000"`
diff --git a/mak/general.mak b/mak/general.mak
index 6f88e4c..c552eb3 100644
--- a/mak/general.mak
+++ b/mak/general.mak
@@ -17,10 +17,16 @@ CFLAGS = -g -O3
 OBJDIR = obj
 endif

-# iconv
+# iconv and -fPIC flags
 ifneq ($(OS),Windows_NT)
-CFLAGS += -DUSE_ICONV
-LIBS += -liconv
+  UNAME_S := $(shell uname -s)
+  ifeq ($(UNAME_S),Darwin)
+    CFLAGS += -DUSE_ICONV
+    LIBS += -liconv
+  endif
+  ifeq ($(UNAME_S),Linux)
+    CFLAGS += -fPIC
+  endif
 endif

 #
