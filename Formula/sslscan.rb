class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.15.tar.gz"
  sha256 "0986ac647098b877f24c863c261bfb7cf545a41fd1120047337dfc44812c69a0"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/rbsec/sslscan.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sslscan"
    sha256 cellar: :any, mojave: "d893afc71c448f40f5f21102ae4dee01851673e168c58920713984273d2222f0"
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
