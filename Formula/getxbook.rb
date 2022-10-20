class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "https://njw.name/getxbook/"
  url "https://njw.name/getxbook/getxbook-1.2.tar.xz"
  sha256 "7a4b1636ecb6dace814b818d9ff6a68167799b81ac6fc4dca1485efd48cf1c46"
  license "ISC"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?getxbook[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/getxbook"
    rebuild 1
    sha256 cellar: :any, mojave: "60b01f682bb204a990e31be879c51dc2a31e646a586fe8f341e8c764031a8a00"
  end

  depends_on "openssl@3"

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end
