class Imagemagick < Formula
  desc "Tools and libraries to manipulate images in many formats"
  homepage "https://imagemagick.org/index.php"
  url "https://www.imagemagick.org/download/releases/ImageMagick-7.1.0-16.tar.xz"
  sha256 "770219ae4087cc9a107dde04473ba7a932a374f310f9ec9ff6a545798e9da039"
  license "ImageMagick"
  head "https://github.com/ImageMagick/ImageMagick.git", branch: "main"

  livecheck do
    url "https://download.imagemagick.org/ImageMagick/download/"
    regex(/href=.*?ImageMagick[._-]v?(\d+(?:\.\d+)+-\d+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/imagemagick"
    rebuild 2
    sha256 mojave: "54d43620114eea6fe148ef87e98bfc3b5ab874820271345a4a15cc3e5c2b4add"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "ghostscript"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "liblqr"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libtool"
  depends_on "little-cms2"
  depends_on "openexr"
  depends_on "openjpeg"
  depends_on "webp"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
  end

  skip_clean :la

  def install
    # Avoid references to shim
    inreplace Dir["**/*-config.in"], "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    args = [
      "--enable-osx-universal-binary=no",
      "--prefix=#{prefix}",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--disable-opencl",
      "--enable-shared",
      "--enable-static",
      "--with-freetype=yes",
      "--with-gvc=no",
      "--with-modules",
      "--with-openjp2",
      "--with-openexr",
      "--with-webp=yes",
      "--with-heic=yes",
      "--with-gslib",
      "--with-gs-font-dir=#{HOMEBREW_PREFIX}/share/ghostscript/fonts",
      "--with-lqr",
      "--without-fftw",
      "--without-pango",
      "--without-wmf",
      "--enable-openmp",
      "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
      "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
      "LDFLAGS=-lomp -lz",
    ]

    args << "--without-x" if OS.mac?

    # versioned stuff in main tree is pointless for us
    inreplace "configure", "${PACKAGE_NAME}-${PACKAGE_BASE_VERSION}", "${PACKAGE_NAME}"
    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "PNG", shell_output("#{bin}/identify #{test_fixtures("test.png")}")
    # Check support for recommended features and delegates.
    features = shell_output("#{bin}/convert -version")
    %w[Modules freetype jpeg png tiff].each do |feature|
      assert_match feature, features
    end
    assert_match "Helvetica", shell_output("#{bin}/identify -list font")
  end
end
