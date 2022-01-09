class Ccextractor < Formula
  desc "Free, GPL licensed closed caption tool"
  homepage "https://www.ccextractor.org/"
  url "https://github.com/CCExtractor/ccextractor/archive/v0.94.tar.gz"
  sha256 "9c7be386257c69b5d8cd9d7466dbf20e3a45cea950cc8ca7486a956c3be54a42"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/ccextractor/ccextractor.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ccextractor"
    sha256 cellar: :any, mojave: "3f2c58c862dafec6db656477105144430a48c71ab6a4e71634b9999f39b951c4"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gpac"
  depends_on "leptonica"
  depends_on "libpng"
  depends_on "protobuf-c"
  depends_on "tesseract"
  depends_on "utf8proc"

  resource "homebrew-test.mxf" do
    url "https://raw.githubusercontent.com/alebcay/example-artifacts/5e8d84effab76c4653972ef72513fcee1d00d3c3/mxf/test.mxf"
    sha256 "e027aca08a2cce64a9fb6623a85306b5481a2f1c3f97a06fd5d3d1b45192b12a"
  end

  # Patch build script to allow building with Homebrew libs rather than upstream's bundled libs
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/e5fddd607fb4e2b6b16044eb47fa3407d4d1fdb0/ccextractor/unbundle-libs.patch"
    sha256 "eb545afad2d1d47a22f50ec0cdad0da11e875d5119213b0e5ace36488f08d237"
  end

  def install
    # Multiple source files reference these dependencies with non-standard #include paths
    ENV["EXTRA_INCLUDE"] = "-I#{Formula["leptonica"].include} -I#{Formula["protobuf-c"].include/"protobuf-c"}"

    if OS.mac?
      platform = "mac"
      build_script = ["./build.command", "OCR"]
    else
      platform = "linux"
      build_script = ["./build", "-without-rust"]
    end

    cd platform do
      system(*build_script)
      bin.install "ccextractor"
    end
    (pkgshare/"examples").install "docs/ccextractor.cnf.sample"
  end

  test do
    resource("homebrew-test.mxf").stage do
      system bin/"ccextractor", "test.mxf", "-out=txt"
      assert_equal "This is a test video.", (Pathname.pwd/"test.txt").read.strip
    end
  end
end
