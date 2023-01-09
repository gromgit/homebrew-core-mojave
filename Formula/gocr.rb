class Gocr < Formula
  desc "Optical Character Recognition (OCR), converts images back to text"
  homepage "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/"
  url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/gocr-0.52.tar.gz"
  sha256 "df906463105f5f4273becc2404570f187d4ea52bd5769d33a7a8661a747b8686"
  revision 2

  livecheck do
    url "https://wasd.urz.uni-magdeburg.de/jschulen/ocr/download.html"
    regex(%r{href=(?:["']?|.*?/)gocr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gocr"
    sha256 cellar: :any_skip_relocation, mojave: "e1cc91bdc03ff0f2e78579030e0e77184ff7a648311ad93dd97ef74892ce40af"
  end

  depends_on "jpeg-turbo"
  depends_on "netpbm"

  # Edit makefile to install libs per developer documentation
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gocr/0.50.patch"
    sha256 "0ed4338c3233a8d1d165f687d6cbe6eee3d393628cdf711a4f8f06b5edc7c4dc"
  end

  def install
    system "./configure", *std_configure_args

    # --mandir doesn't work correctly; fix broken Makefile
    inreplace "man/Makefile" do |s|
      s.change_make_var! "mandir", "/share/man"
    end

    system "make", "libs"
    system "make", "install"
  end

  test do
    system bin/"gocr", "--help"
  end
end
