class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftp.gnu.org/gnu/gsasl/gsasl-2.2.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/gsasl/gsasl-2.2.0.tar.gz"
  sha256 "79b868e3b9976dc484d59b29ca0ae8897be96ce4d36d32aed5d935a7a3307759"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gsasl"
    sha256 mojave: "8d679d6664559e04f68e9a98f44afaeb0fdd67617f2a86493ef90290cf39c76f"
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
