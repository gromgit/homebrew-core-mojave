class JpegXl < Formula
  desc "New file format for still image compression"
  homepage "https://jpeg.org/jpegxl/index.html"
  url "https://github.com/libjxl/libjxl/archive/v0.6.1.tar.gz"
  sha256 "ccbd5a729d730152303be399f033b905e608309d5802d77a61a95faa092592c5"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpeg-xl"
    rebuild 2
    sha256 cellar: :any, mojave: "843c9009108eba0b97c0110393f63387ce2d1efab8627f626cb776f40a78bfa3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openexr"
  depends_on "webp"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build # for xsltproc

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  # These resources are versioned according to the script supplied with jpeg-xl to download the dependencies:
  # https://github.com/libjxl/libjxl/tree/v#{version}/third_party
  resource "highway" do
    url "https://github.com/google/highway.git",
        revision: "e2397743fe092df68b760d358253773699a16c93"
  end

  resource "lodepng" do
    url "https://github.com/lvandeve/lodepng.git",
        revision: "48e5364ef48ec2408f44c727657ac1b6703185f8"
  end

  resource "sjpeg" do
    url "https://github.com/webmproject/sjpeg.git",
        revision: "868ab558fad70fcbe8863ba4e85179eeb81cc840"
  end

  resource "skcms" do
    url "https://skia.googlesource.com/skcms.git",
        revision: "64374756e03700d649f897dbd98c95e78c30c7da"
  end

  # remove when https://github.com/libjxl/libjxl/commit/88fe3fff3dc70c72405f57c69feffd9823930034 is in a tag
  patch do
    url "https://github.com/libjxl/libjxl/commit/88fe3fff3dc70c72405f57c69feffd9823930034.patch?full_index=1"
    sha256 "a1dba15e75093dea2d16d4fb1341e1ba8ba8400be723cb887a190d4d525ce9a6"
  end

  def install
    resources.each { |r| r.stage buildpath/"third_party"/r.name }
    mkdir "build" do
      # disable manpages due to problems with asciidoc 10
      system "cmake", "..", "-DBUILD_TESTING=OFF",
        "-DJPEGXL_FORCE_SYSTEM_BROTLI=ON",
        "-DJPEGXL_ENABLE_JNI=OFF",
        "-DJPEGXL_VERSION=#{version}",
        "-DJPEGXL_ENABLE_MANPAGES=OFF",
        *std_cmake_args
      system "cmake", "--build", "."
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system "#{bin}/cjxl", test_fixtures("test.jpg"), "test.jxl"
    assert_predicate testpath/"test.jxl", :exist?
  end
end
