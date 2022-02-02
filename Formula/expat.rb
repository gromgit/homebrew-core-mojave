class Expat < Formula
  desc "XML 1.0 parser"
  homepage "https://libexpat.github.io/"
  url "https://github.com/libexpat/libexpat/releases/download/R_2_4_3/expat-2.4.3.tar.xz"
  sha256 "b1f9f1b1a5ebb0acaa88c9ff79bfa4e145823b78aa5185e5c5d85f060824778a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?expat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/expat"
    sha256 cellar: :any, mojave: "52bb212887c82c5074e0aa6afef553709652acab5282c6ad7fd80ecc8fb73000"
  end

  head do
    url "https://github.com/libexpat/libexpat.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "docbook2x" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_macos

  def install
    cd "expat" if build.head?
    system "autoreconf", "-fiv" if build.head?
    args = ["--prefix=#{prefix}", "--mandir=#{man}"]
    args << "--with-docbook" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "expat.h"

      static void XMLCALL my_StartElementHandler(
        void *userdata,
        const XML_Char *name,
        const XML_Char **atts)
      {
        printf("tag:%s|", name);
      }

      static void XMLCALL my_CharacterDataHandler(
        void *userdata,
        const XML_Char *s,
        int len)
      {
        printf("data:%.*s|", len, s);
      }

      int main()
      {
        static const char str[] = "<str>Hello, world!</str>";
        int result;

        XML_Parser parser = XML_ParserCreate("utf-8");
        XML_SetElementHandler(parser, my_StartElementHandler, NULL);
        XML_SetCharacterDataHandler(parser, my_CharacterDataHandler);
        result = XML_Parse(parser, str, sizeof(str), 1);
        XML_ParserFree(parser);

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lexpat", "-o", "test"
    assert_equal "tag:str|data:Hello, world!|", shell_output("./test")
  end
end
