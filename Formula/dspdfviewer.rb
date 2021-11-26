class Dspdfviewer < Formula
  desc "Dual-Screen PDF Viewer for latex-beamer"
  homepage "https://dspdfviewer.danny-edel.de/"
  url "https://github.com/dannyedel/dspdfviewer/archive/v1.15.1.tar.gz"
  sha256 "c5b6f8c93d732e65a27810286d49a4b1c6f777d725e26a207b14f6b792307b03"
  license "GPL-2.0-or-later"
  revision 11
  head "https://github.com/dannyedel/dspdfviewer.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dspdfviewer"
    rebuild 1
    sha256 cellar: :any, mojave: "3dc6ff0560ab47dcbca028b65c370aa538819f1d6885c6ac1df5f889b3a71e6c"
  end

  depends_on "cmake" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "poppler-qt5"
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DRunDualScreenTests=OFF",
                            "-DUsePrerenderedPDF=ON",
                            "-DUseQtFive=ON"
      system "make", "install"
    end
  end

  test do
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux?
    system "#{bin}/dspdfviewer", "--help"
  end
end
