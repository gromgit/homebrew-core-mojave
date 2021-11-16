class Balance < Formula
  desc "Software load balancer"
  homepage "https://www.inlab.net/balance/"
  url "https://www.inlab.net/wp-content/uploads/2018/05/balance-3.57.tar.gz"
  sha256 "b355f98932a9f4c9786cb61012e8bdf913c79044434b7d9621e2fa08370afbe1"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "4b170d08a0e4d13fe80d1d7574945e56d5a7d78507c6b880f60950ce98d7ffea"
    sha256 cellar: :any_skip_relocation, mojave:      "1b572db3df89cacc7d1fc1f26d9247900f5bada4efe14ba48051900c70d1dece"
    sha256 cellar: :any_skip_relocation, high_sierra: "77589c441e2c89d6fb3df19b51487fb4684327fe63c5fe768224d10f81868d3c"
    sha256 cellar: :any_skip_relocation, sierra:      "02b241cd5085873f6f2e78c99c01b1be6c89a3a2ff9fc12e17600035096dc44e"
    sha256 cellar: :any_skip_relocation, el_capitan:  "c6af3ec64f795a6ba24400e83b3ab3753564a57f8546f0137368860bd2605421"
    sha256 cellar: :any_skip_relocation, yosemite:    "07f517fc19b99e5d52f6a90576ccd718650bd6a291d7c808f0d8b8193bce7779"
  end

  disable! date: "2020-12-08", because: :unmaintained

  def install
    system "make"
    bin.install "balance"
    man1.install "balance.1"
  end

  test do
    output = shell_output("#{bin}/balance 2>&1", 64)
    assert_match "this is balance #{version}", output
  end
end
