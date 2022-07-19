class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/v1.9.0.tar.gz"
  sha256 "a3910b9b844e05ee55838aa17beddc6aa9d6c5c0012eab647a21cc9ccd6c8749"
  license "Apache-2.0"
  head "https://github.com/shekyan/slowhttptest.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/slowhttptest"
    sha256 cellar: :any, mojave: "b813e2e20acad18b7474f3d2d0c91544cbfd524d96efeb434b17e9c1dc43cd1c"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"

    assert_match version.to_s, shell_output("#{bin}/slowhttptest -h", 1)
  end
end
