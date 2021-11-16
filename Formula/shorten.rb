class Shorten < Formula
  desc "Waveform compression"
  homepage "https://web.archive.org/web/20180903155129/www.etree.org/shnutils/shorten/"
  url "https://web.archive.org/web/20180903155129/www.etree.org/shnutils/shorten/dist/src/shorten-3.6.1.tar.gz"
  sha256 "ce22e0676c93494ee7d094aed9b27ad018eae5f2478e8862ae1e962346405b66"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "4316e27eb009a503852bd285d9bb733df4d09bd3eb7845ed250ae787be02f896"
    sha256 cellar: :any_skip_relocation, mojave:      "ed0a7482bebdc53827e6932bdc70d8897d00b4ce87ac2cf84bee7b0cec2229a5"
    sha256 cellar: :any_skip_relocation, high_sierra: "2247094c6f41ad5ce941c84335a45aaaabe0bef43ffeb89a544793957c157ba9"
    sha256 cellar: :any_skip_relocation, sierra:      "a54b8263dfbd2aab185df1888193dc0ceb602d9df82758cf5ef31b3df52ae697"
    sha256 cellar: :any_skip_relocation, el_capitan:  "66cf7cabae065035e9c3c4a8c139439384fb9f26ea0ee433e336c18ba2f8383e"
    sha256 cellar: :any_skip_relocation, yosemite:    "5f48b61ce709915830f433dd381fe531c1354b56619bbdb441dc19f985df7467"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shorten", test_fixtures("test.wav"), "test"
    assert_predicate testpath/"test", :exist?
  end
end
