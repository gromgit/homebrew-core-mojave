class Alpine < Formula
  desc "News and email agent"
  homepage "https://alpineapp.email"
  url "https://alpineapp.email/alpine/release/src/alpine-2.25.tar.xz"
  mirror "https://alpineapp.email/alpine/release/src/Old/alpine-2.25.tar.xz"
  sha256 "658a150982f6740bb4128e6dd81188eaa1212ca0bf689b83c2093bb518ecf776"
  license "Apache-2.0"
  revision 1
  head "https://repo.or.cz/alpine.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?alpine[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/alpine"
    rebuild 3
    sha256 mojave: "2b2b461a4be7574df60bff6105ecf1b5bb499c98a6b0b31850f48c2a95ce5b6e"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"
  uses_from_macos "openldap"

  on_linux do
    depends_on "linux-pam"
  end

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
      --with-bundled-tools
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-conf"
  end
end
