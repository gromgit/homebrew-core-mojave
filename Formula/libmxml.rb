class Libmxml < Formula
  desc "Mini-XML library"
  homepage "https://michaelrsweet.github.io/mxml/"
  url "https://github.com/michaelrsweet/mxml/releases/download/v3.3/mxml-3.3.tar.gz"
  sha256 "7cf976366f9e8e4f8cff7d35a59bcf6201c769fce9e58015d64f4b6de1fe3dd8"
  license "Apache-2.0"
  head "https://github.com/michaelrsweet/mxml.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmxml"
    rebuild 2
    sha256 cellar: :any, mojave: "c1ad950de784d492d78b7a79d9e9c1c7d80ccc88e5efcc33954e21588b8650a7"
  end

  depends_on xcode: :build # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mxml.h>

      int main()
      {
        FILE *fp;
        mxml_node_t *tree;

        fp = fopen("test.xml", "r");
        tree = mxmlLoadFile(NULL, fp, MXML_OPAQUE_CALLBACK);
        fclose(fp);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <test>
        <text>I'm an XML document.</text>
      </test>
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmxml", "-o", "test"
    system "./test"
  end
end
