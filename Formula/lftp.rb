class Lftp < Formula
  desc "Sophisticated file transfer program"
  homepage "https://lftp.yar.ru/"
  url "https://lftp.yar.ru/ftp/lftp-4.9.2.tar.xz"
  sha256 "c517c4f4f9c39bd415d7313088a2b1e313b2d386867fe40b7692b83a20f0670d"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/lavv17/lftp.git"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lftp"
    rebuild 1
    sha256 mojave: "a6bd2170908aabd6bd1f9c8d7b0e5156a4cccc7ad7f276de9d0e65b15d197efa"
  end

  depends_on "libidn2"
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  def install
    # Work around "error: no member named 'fpclassify' in the global namespace"
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    # Work around configure issues with Xcode 12
    # https://github.com/lavv17/lftp/issues/611
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--with-libidn2=#{Formula["libidn2"].opt_prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/lftp", "-c", "open https://ftp.gnu.org/; ls"
  end
end
