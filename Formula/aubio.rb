class Aubio < Formula
  desc "Extract annotations from audio signals"
  homepage "https://aubio.org/"
  url "https://aubio.org/pub/aubio-0.4.9.tar.bz2"
  sha256 "d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da"
  revision 3

  livecheck do
    url "https://aubio.org/pub/"
    regex(/href=.*?aubio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aubio"
    rebuild 1
    sha256 cellar: :any, mojave: "5f4fd18fc69a5fc2574d1ff37c7a938ca0f95a0a9e8ce21cc89d22ed685de370"
  end

  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "numpy"
  depends_on "python@3.10"

  on_linux do
    depends_on "libsndfile"
  end

  resource "aiff" do
    url "http://www-mmsp.ece.mcgill.ca/Documents/AudioFormats/AIFF/Samples/CCRMA/wood24.aiff"
    sha256 "a87279e3a101162f6ab0d4f70df78594d613e16b80e6257cf19c5fc957a375f9"
  end

  def install
    # Needed due to issue with recent clang (-fno-fused-madd))
    ENV.refurbish_args

    # Ensure `python` references use our python3
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "python3", "./waf", "build"
    system "python3", "./waf", "install"

    system "python3", *Language::Python.setup_install_args(prefix),
                      "--install-lib=#{prefix/Language::Python.site_packages("python3")}"
  end

  test do
    testpath.install resource("aiff")
    system bin/"aubiocut", "--verbose", "wood24.aiff"
    system bin/"aubioonset", "--verbose", "wood24.aiff"
  end
end
