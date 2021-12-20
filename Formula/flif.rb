class Flif < Formula
  desc "Free Loseless Image Format"
  homepage "https://flif.info/"
  url "https://github.com/FLIF-hub/FLIF/archive/v0.4.tar.gz"
  sha256 "cc98313ef0dbfef65d72bc21f730edf2a97a414f14bd73ad424368ce032fdb7f"
  license "LGPL-3.0-or-later"
  head "https://github.com/FLIF-hub/FLIF.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flif"
    sha256 cellar: :any, mojave: "43fd3598eb2f7663c380ceb9460c4ab89ddc1592c65ea6e95139166d4cefa48d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "sdl2"

  resource "homebrew-test_c" do
    url "https://raw.githubusercontent.com/FLIF-hub/FLIF/dcc2011/tools/test.c"
    sha256 "a20b625ba0efdb09ad21a8c1c9844f686f636656f0e9bd6c24ad441375223afe"
  end

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    doc.install "doc/flif.pdf"
  end

  test do
    testpath.install resource("homebrew-test_c")
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lflif", "-o", "test"
    system "./test", "dummy.flif"
    system bin/"flif", "-i", "dummy.flif"
    system bin/"flif", "-I", test_fixtures("test.png"), "test.flif"
    system bin/"flif", "-d", "test.flif", "test.png"
    assert_predicate testpath/"test.png", :exist?, "Failed to decode test.flif"
  end
end
