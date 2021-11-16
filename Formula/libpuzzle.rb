class Libpuzzle < Formula
  desc "Library to find visually similar images"
  homepage "https://www.pureftpd.org/project/libpuzzle"
  url "https://download.pureftpd.org/pub/pure-ftpd/misc/libpuzzle/releases/libpuzzle-0.11.tar.bz2"
  sha256 "ba628268df6956366cbd44ae48c3f1bab41e70b4737041a1f33dac9832c44781"
  license "ISC"

  bottle do
    rebuild 2
    sha256 cellar: :any, catalina:    "858f964b7cbbde7c37abd6915d64f4a25f9a37e85e1d2ec841e9a2c37b591de9"
    sha256 cellar: :any, mojave:      "fa41c55ca3bee07a45c5b77c91137dcf9e34852d6bbb9467e3f84a8f233361eb"
    sha256 cellar: :any, high_sierra: "017b32e2b389f87bc7445476d67543dd711cdac34374da0958d70a4682a706a7"
    sha256 cellar: :any, sierra:      "62452be0513886b00ad766fc6c444f69af8a70d89948a65b3fe201c12383f536"
    sha256 cellar: :any, el_capitan:  "0768fc24347a5e5e061722175cae535b6e295c28302d98ad3e03dc9f79a32bf0"
    sha256 cellar: :any, yosemite:    "d8f7de77378d0fa29e34876ccc8def7f8e60e6564a1c17dae77f4c32ebd8ae5a"
  end

  disable! date: "2020-12-08", because: :unmaintained

  depends_on "gd"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_equal "0",
      shell_output("#{bin}/puzzle-diff #{test_image} #{test_image}").chomp
  end
end
