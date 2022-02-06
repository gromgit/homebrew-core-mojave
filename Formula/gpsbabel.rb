class Gpsbabel < Formula
  desc "Converts/uploads GPS waypoints, tracks, and routes"
  homepage "https://www.gpsbabel.org/"
  url "https://github.com/GPSBabel/gpsbabel/archive/gpsbabel_1_8_0.tar.gz"
  sha256 "448379f0bf5f5e4514ed9ca8a1069b132f4d0e2ab350e2277e0166bf126b0832"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^gpsbabel[._-]v?(\d+(?:[._]\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gpsbabel"
    sha256 mojave: "68008f2a04af7d6a86635b7080731cc173bf81186eed64482b6de8efbb9c5635"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"
  depends_on "qt"
  depends_on "shapelib"

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11
    # force use of homebrew libusb-1.0 instead of included version.
    # force use of homebrew shapelib instead of included version.
    # force use of system zlib instead of included version.
    rm_r "mac/libusb"
    rm_r "shapelib"
    rm_r "zlib"
    shapelib = Formula["shapelib"]
    system "qmake", "GPSBabel.pro",
           "WITH_LIBUSB=pkgconfig",
           "WITH_SHAPELIB=custom", "INCLUDEPATH+=#{shapelib.opt_include}", "LIBS+=-L#{shapelib.opt_lib} -lshp",
           "WITH_ZLIB=pkgconfig"
    system "make"
    bin.install "gpsbabel"
  end

  test do
    (testpath/"test.loc").write <<~EOS
      <?xml version="1.0"?>
      <loc version="1.0">
        <waypoint>
          <name id="1 Infinite Loop"><![CDATA[Apple headquarters]]></name>
          <coord lat="37.331695" lon="-122.030091"/>
        </waypoint>
      </loc>
    EOS
    system bin/"gpsbabel", "-i", "geo", "-f", "test.loc", "-o", "gpx", "-F", "test.gpx"
    assert_predicate testpath/"test.gpx", :exist?
  end
end
