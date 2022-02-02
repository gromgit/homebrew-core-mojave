class Dxflib < Formula
  desc "C++ library for parsing DXF files"
  homepage "https://www.ribbonsoft.com/en/what-is-dxflib"
  url "https://www.ribbonsoft.com/archives/dxflib/dxflib-3.26.4-src.tar.gz"
  sha256 "507db4954b50ac521cbb2086553bf06138dc89f55196a8ba22771959c760915f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ribbonsoft.com/en/dxflib-downloads"
    regex(/href=.*?dxflib[._-]v?(\d+(?:\.\d+)+)-src\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dxflib"
    sha256 cellar: :any, mojave: "6f550cb6f1077852931f975dce5b8ed1b2c2e906d0352def7e736e683a90f25a"
  end

  depends_on "qt" => :build

  # Sample DXF file made available under GNU LGPL license.
  # See https://people.math.sc.edu/Burkardt/data/dxf/dxf.html.
  resource "testfile" do
    url "https://people.math.sc.edu/Burkardt/data/dxf/cube.dxf"
    sha256 "e5744edaa77d1612dec44d1a47adad4aad3d402dbf53ea2aff5a57c34ae9bafa"
  end

  def install
    # For libdxflib.a
    system "qmake", "dxflib.pro"
    system "make"

    # Build shared library
    inreplace "dxflib.pro", "CONFIG += staticlib", "CONFIG += shared"
    system "qmake", "dxflib.pro"
    system "make"

    (include/"dxflib").install Dir["src/*"]
    lib.install Dir["*.a", shared_library("*")]
  end

  test do
    resource("testfile").stage testpath

    (testpath/"test.cpp").write <<~EOS
      #include <dxflib/dl_dxf.h>
      #include <dxflib/dl_creationadapter.h>

      using namespace std;

      class MyDxfFilter : public DL_CreationAdapter {
        virtual void addLine(const DL_LineData& d);
      };

      void MyDxfFilter::addLine(const DL_LineData& d) {
        cout << d.x1 << "/" << d.y1 << " "
             << d.x2 << "/" << d.y2 << endl;
      }

      int main() {
        MyDxfFilter f;
        DL_Dxf* dxf = new DL_Dxf();
        dxf->test();
        if (!dxf->in("cube.dxf", &f)) return 1;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test",
           "-I#{include}/dxflib", "-L#{lib}", "-ldxflib"
    output = shell_output("./test")
    assert_match "1 buf1: '  10", output
    assert_match "2 buf1: '10'", output
    assert_match "-0.5/-0.5 0.5/-0.5", output.split("\n")[16]
  end
end
