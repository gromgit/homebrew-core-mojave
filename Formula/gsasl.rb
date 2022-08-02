class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-2.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-2.0.1.tar.gz"
  sha256 "322c7542008841bcd8ba4ae0933b220211d190a7b56a70dd61f6556decc01b7a"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gsasl"
    sha256 mojave: "0787ba4dc5edef745a84413454b20a391dde2a8c33124ba2f172ee49e2f5bd07"
  end

  depends_on "libgcrypt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gsasl --version")
  end
end
