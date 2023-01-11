class Ircii < Formula
  desc "IRC and ICB client"
  homepage "http://www.eterna.com.au/ircii/"
  url "https://ircii.warped.com/ircii-20210314.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/i/ircii/ircii_20210314.orig.tar.bz2"
  sha256 "866f2b847daed3d70859f208f7cb0f20b58c0933b2159f7ff92a68c518d393a9"
  license all_of: [
    "BSD-3-Clause",
    "BSD-2-Clause",
    "GPL-2.0-or-later",
    "MIT",
    :public_domain,
  ]

  livecheck do
    url "https://ircii.warped.com/"
    regex(/href=.*?ircii[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ircii"
    rebuild 3
    sha256 mojave: "7ede52c75e5f08f2270e7c5d4ab6ab9c8419ffd22856967c54c18a427c74adfe"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    ENV.append "LIBS", "-liconv" if OS.mac?
    system "./configure", "--prefix=#{prefix}",
                          "--with-default-server=irc.libera.chat",
                          "--enable-ipv6"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    IO.popen("#{bin}/irc -d", "r+") do |pipe|
      assert_match "Connecting to port 6667 of server irc.libera.chat", pipe.gets
      pipe.puts "/quit"
      pipe.close_write
      pipe.close
    end
  end
end
