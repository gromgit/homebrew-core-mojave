class Fltk < Formula
  desc "Cross-platform C++ GUI toolkit"
  homepage "https://www.fltk.org/"
  url "https://www.fltk.org/pub/fltk/1.3.8/fltk-1.3.8-source.tar.gz"
  sha256 "f3c1102b07eb0e7a50538f9fc9037c18387165bc70d4b626e94ab725b9d4d1bf"
  license "LGPL-2.0-only" => { with: "FLTK-exception" }

  livecheck do
    url "https://www.fltk.org/software.php"
    regex(/href=.*?fltk[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)-source\.t/i)
  end

  head do
    url "https://github.com/fltk/fltk.git"
    depends_on "cmake" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libxft"
    depends_on "libxt"
    depends_on "mesa-glu"
  end

  def install
    if build.head?
      args = std_cmake_args

      # Don't build docs / require doxygen
      args << "-DOPTION_BUILD_HTML_DOCUMENTATION=OFF"
      args << "-DOPTION_BUILD_PDF_DOCUMENTATION=OFF"

      # Don't build tests
      args << "-DFLTK_BUILD_TEST=OFF"

      # Build both shared & static libs
      args << "-DOPTION_BUILD_SHARED_LIBS=ON"

      system "cmake", ".", *args
      system "cmake", "--build", "."
      system "cmake", "--install", "."
    else
      system "./configure", "--prefix=#{prefix}",
                            "--enable-threads",
                            "--enable-shared"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <FL/Fl.H>
      #include <FL/Fl_Window.H>
      #include <FL/Fl_Box.H>
      int main(int argc, char **argv) {
        Fl_Window *window = new Fl_Window(340,180);
        Fl_Box *box = new Fl_Box(20,40,300,100,"Hello, World!");
        box->box(FL_UP_BOX);
        box->labelfont(FL_BOLD+FL_ITALIC);
        box->labelsize(36);
        box->labeltype(FL_SHADOW_LABEL);
        window->end();
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lfltk", "-o", "test"
    system "./test"
  end
end
