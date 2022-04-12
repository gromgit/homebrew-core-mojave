class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.16.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.16.3.tar.gz"
  sha256 "3239052f13537a9aabaaa66ec42875dbee2f6838c5f18b3aef854e6b531ec38a"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gnunet"
    sha256 cellar: :any, mojave: "9d643315e21faf0c5d9ecad81107b521f7ea7298597a39a5e882c5cafd99be9c"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libunistring"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    ENV.deparallelize if OS.linux?
    system "./configure", "--prefix=#{prefix}", "--with-microhttpd"
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
