class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v9e.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v9e.tar.gz"
  sha256 "4077d6a6a75aeb01884f708919d25934c93305e49f7e3f36db9129320e6f4f3d"
  license "IJG"

  livecheck do
    url "https://www.ijg.org/files/"
    regex(/href=.*?jpegsrc[._-]v?(\d+[a-z]?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jpeg"
    sha256 cellar: :any, mojave: "a1c266a851f6f6d50d7f0e47da2ab88819b9b3db0229c91809ac5504f28fe1d3"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/djpeg", test_fixtures("test.jpg")
  end
end
