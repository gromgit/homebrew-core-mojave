class Tesseract < Formula
  desc "OCR (Optical Character Recognition) engine"
  homepage "https://github.com/tesseract-ocr/"
  url "https://github.com/tesseract-ocr/tesseract/archive/4.1.1.tar.gz"
  sha256 "2a66ff0d8595bff8f04032165e6c936389b1e5727c3ce5a27b3e059d218db1cb"
  license "Apache-2.0"
  head "https://github.com/tesseract-ocr/tesseract.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "61033b6bf5aa12565463d079c872c81f2913527aa84311b4b6b1ad5293e02dd9"
    sha256 cellar: :any,                 arm64_big_sur:  "038495152035dbed8ed578eab3c98c911d608ff50ac02ceb8f8408c762d01a27"
    sha256 cellar: :any,                 monterey:       "3b5d8e3ec5df37bb07cc39c0a61253d8236e59cb2021c0dbd134da2a8734bb3c"
    sha256 cellar: :any,                 big_sur:        "6d49823b55a5093041b94bad0fb34e3a06c13d7ec0c677765ee64a88a3608fc0"
    sha256 cellar: :any,                 catalina:       "81ff467946d9c85151c86819034cd183a983b4a3fa10374c7f039a5ec3ef0d82"
    sha256 cellar: :any,                 mojave:         "34eee505fccec07eaab30f14c46f9688db9f3aa578306d47bbcd31801b0b849d"
    sha256 cellar: :any,                 high_sierra:    "6b64585454bcca9b62945b284000723d76afad15b5e80109ca6cdc699ae50e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66b1efe4ccce2f26b0a64b293260042fce0f2b0d5fcdf4a5f63c2887ba5bee11"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "leptonica"
  depends_on "libtiff"

  resource "eng" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.0.0/eng.traineddata"
    sha256 "7d4322bd2a7749724879683fc3912cb542f19906c83bcc1a52132556427170b2"
  end

  resource "osd" do
    url "https://github.com/tesseract-ocr/tessdata_fast/raw/4.0.0/osd.traineddata"
    sha256 "9cf5d576fcc47564f11265841e5ca839001e7e6f38ff7f7aacf46d15a96b00ff"
  end

  resource "snum" do
    url "https://github.com/USCDataScience/counterfeit-electronics-tesseract/raw/319a6eeacff181dad5c02f3e7a3aff804eaadeca/Training%20Tesseract/snum.traineddata"
    sha256 "36f772980ff17c66a767f584a0d80bf2302a1afa585c01a226c1863afcea1392"
  end

  resource "testfile" do
    url "https://raw.githubusercontent.com/tesseract-ocr/test/6dd816cdaf3e76153271daf773e562e24c928bf5/testing/eurotext.tif"
    sha256 "7b9bd14aba7d5e30df686fbb6f71782a97f48f81b32dc201a1b75afe6de747d6"
  end

  # Fix `#include <version>` bug with newer Xcode.
  # https://github.com/tesseract-ocr/tesseract/issues/3447
  patch do
    url "https://github.com/tesseract-ocr/tesseract/commit/6dc4b184b1ebf2e68461f6b63f63a033bc7245f7.patch?full_index=1"
    sha256 "a2e64ce125c93c05e7ec6c9dd47845b605d1b95a4d00d1c40a6ee706c5029ca3"
  end

  def install
    # explicitly state leptonica header location, as the makefile defaults to /usr/local/include,
    # which doesn't work for non-default homebrew location
    ENV["LIBLEPT_HEADERSDIR"] = HOMEBREW_PREFIX/"include"

    ENV.cxx11

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--datarootdir=#{HOMEBREW_PREFIX}/share"

    system "make"

    # make install in the local share folder to avoid permission errors
    system "make", "install", "datarootdir=#{share}"

    resource("snum").stage { mv "snum.traineddata", share/"tessdata" }
    resource("eng").stage { mv "eng.traineddata", share/"tessdata" }
    resource("osd").stage { mv "osd.traineddata", share/"tessdata" }
  end

  def caveats
    <<~EOS
      This formula contains only the "eng", "osd", and "snum" language data files.
      If you need any other supported languages, run `brew install tesseract-lang`.
    EOS
  end

  test do
    resource("testfile").stage do
      system bin/"tesseract", "./eurotext.tif", "./output", "-l", "eng"
      assert_match "The (quick) [brown] {fox} jumps!\n", File.read("output.txt")
    end
  end
end
