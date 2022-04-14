class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.13.tar.gz"
  sha256 "34549613e16ba5dbfca3d988672041b7b0ece6f408515d6ba8819e2d804b5833"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sslscan"
    sha256 cellar: :any, mojave: "d43ad77f17fc4d1b49a99311ef138a5433698895680c9ae80139aab6a64f7f39"
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib|so` built from `openssl@1.1`
    inreplace "Makefile", "./openssl/libssl.a",
                          "#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libssl")}"
    inreplace "Makefile", "./openssl/libcrypto.a",
                          "#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
