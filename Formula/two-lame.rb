class TwoLame < Formula
  desc "Optimized MPEG Audio Layer 2 (MP2) encoder"
  homepage "https://www.twolame.org/"
  url "https://downloads.sourceforge.net/project/twolame/twolame/0.4.0/twolame-0.4.0.tar.gz"
  sha256 "cc35424f6019a88c6f52570b63e1baf50f62963a3eac52a03a800bb070d7c87d"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b49ddbaac0612e42ffcfa8cda457d5602063d645f124da8c6353f15abc5c9c5"
    sha256 cellar: :any,                 arm64_big_sur:  "15f7868c873400af4b2f9e566356bfa00217f563d51511120367c4dc75d2867f"
    sha256 cellar: :any,                 monterey:       "5f40da46c678cf30b76918f6ba6d38a80425fe52b6fd06c290608de175b3cfad"
    sha256 cellar: :any,                 big_sur:        "4847a0b0e48b6f8ac14113793e18a6b31d8dce22b09dc707c35306ec2b3ecdfa"
    sha256 cellar: :any,                 catalina:       "9ba9f3afb14f2ac2fa911046a83ee50ed6a93d747f0c305788a61b4138e5fe5a"
    sha256 cellar: :any,                 mojave:         "77d5c37574ecdf0d857e09f47e9de5eda3049fe8cd1486942a6a62a4baae6f06"
    sha256 cellar: :any,                 high_sierra:    "153c7085434a1bce73b0ce704f37997179d6e53614a7014546b9b4d3f80dec97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a0261525798a434c29f332eaa62ed01cf06c4bb2bdf76a64cdf2e6a46fd1b0a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "simplefrontend/.libs/stwolame"
  end

  test do
    system "#{bin}/stwolame", test_fixtures("test.wav"), "test.mp2"
  end
end
