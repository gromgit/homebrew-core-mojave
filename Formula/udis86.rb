class Udis86 < Formula
  desc "Minimalistic disassembler library for x86"
  homepage "https://udis86.sourceforge.io"
  url "https://downloads.sourceforge.net/project/udis86/udis86/1.7/udis86-1.7.2.tar.gz"
  sha256 "9c52ac626ac6f531e1d6828feaad7e797d0f3cce1e9f34ad4e84627022b3c2f4"

  livecheck do
    url :stable
    regex(%r{url=.*?/udis86[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2784b5cdecb76514ce3a56f1343e851915cf1f9e5453a9db9eb54a42436903be"
    sha256 cellar: :any, big_sur:       "8d2407363a0ba95163d3689f83e7b1fce331c61a9fecbc6e6c0476af9435f347"
    sha256 cellar: :any, catalina:      "28f761b215237ed656359cce94fd4787be86a50057dc064589f6bbedbcf2fe06"
    sha256 cellar: :any, mojave:        "b510a8349883e86135cf030953df54b671cf668a1e3e5020fc059a0f6f92a52d"
    sha256 cellar: :any, high_sierra:   "cefad0043918886a862a040adf2450699c00cbef3fd561bbc8867e2328b16ac8"
    sha256 cellar: :any, sierra:        "e3774a825eda78db57585c75b739dc60d0c069e35c8666575f5889908b0735d5"
    sha256 cellar: :any, el_capitan:    "e763db7beca50f11ab341f13f5fd571513f4847772bb70ef83d94bb576427673"
    sha256 cellar: :any, yosemite:      "bcd6eb347f55bc856ceb64604d3bace30219e346de34caa8be7de2b52a1cb35d"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"
    system "make"
    system "make", "install"
  end

  test do
    assert_match("int 0x80", pipe_output("#{bin}/udcli -x", "cd 80").split.last(2).join(" "))
  end
end
