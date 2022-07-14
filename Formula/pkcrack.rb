class Pkcrack < Formula
  desc "Implementation of an algorithm for breaking the PkZip cipher"
  homepage "https://web.archive.org/web/20220128084028/https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html"
  url "https://web.archive.org/web/20140725082030/https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-1.2.2.tar.gz"
  mirror "https://pkg.freebsd.org/ports-distfiles/pkcrack-1.2.2.tar.gz"
  sha256 "4d2dc193ffa4342ac2ed3a6311fdf770ae6a0771226b3ef453dca8d03e43895a"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41fac1d66b167e630a47d183df3ef169d0c61e19538b783442f2951371807b53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4ee4c3916070396ad7bd3fdcf550cd150f33359381a177784015a06a4fed9e8"
    sha256 cellar: :any_skip_relocation, monterey:       "eb4e5a960e8da28789c0f702c751338039358f985864f1194cc7637ab0d342e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2dd9784714a8b28083cf1d68d6f0c36515e90a2a6ae4ff079aaa33a563a310e"
    sha256 cellar: :any_skip_relocation, catalina:       "d3a30eacefe197d458f08b01ad58d778376fc5b4d53c35f7c0e5c525c17c32d0"
    sha256 cellar: :any_skip_relocation, mojave:         "43571237e186fe6907bef85b5584772b80ed96b7336e55c47a1b18a41ef75278"
    sha256 cellar: :any_skip_relocation, high_sierra:    "13c80200a6a1b96c74c590c595c1860447b04a6bb44d10210d82e0fa53e8f61b"
    sha256 cellar: :any_skip_relocation, sierra:         "264358646b08985192cd06c9bc032c16296eb00198dd9852521e0cfdfe1703ef"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9b46e1c0097cc4024d4f5b182ac8fdbc27e3caec52874b19d570aba6f946fc10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7166064fd3c5a549df696d4d889b4de6c5d2596f70c598de71a3d975a42a8f3c"
  end

  deprecate! date: "2022-03-30", because: :unmaintained # and upstream site is gone

  conflicts_with "csound", because: "both install `extract` binaries"
  conflicts_with "libextractor", because: "both install `extract` binaries"

  def install
    # Fix "fatal error: 'malloc.h' file not found"
    # Reported 18 Sep 2017 to conrad AT unix-ag DOT uni-kl DOT de
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/malloc"

    system "make", "-C", "src/"
    bin.install Dir["src/*"].select { |f| File.executable? f }
  end

  test do
    shell_output("#{bin}/pkcrack", 1)
  end
end
