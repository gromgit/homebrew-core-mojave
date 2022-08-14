class Siege < Formula
  desc "HTTP regression testing and benchmarking utility"
  homepage "https://www.joedog.org/siege-home/"
  url "http://download.joedog.org/siege/siege-4.1.5.tar.gz"
  sha256 "076df9fcdb7f63c46d6f661acc2ccc8405937ae9cae490ab8a9d78a9d2e7b8cb"
  license "GPL-3.0-or-later"

  livecheck do
    url "http://download.joedog.org/siege/?C=M&O=D"
    regex(/href=.*?siege[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/siege"
    sha256 mojave: "0af4db70b42ff178b1cbec9af34df5ee29728a6dd6e457ccff27eba70e1aa273"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # To avoid unnecessary warning due to hardcoded path, create the folder first
    (prefix/"etc").mkdir
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-zlib=#{MacOS.sdk_path_if_needed}/usr"
    system "make", "install"
  end

  def caveats
    <<~EOS
      macOS has only 16K ports available that won't be released until socket
      TIME_WAIT is passed. The default timeout for TIME_WAIT is 15 seconds.
      Consider reducing in case of available port bottleneck.

      You can check whether this is a problem with netstat:

          # sysctl net.inet.tcp.msl
          net.inet.tcp.msl: 15000

          # sudo sysctl -w net.inet.tcp.msl=1000
          net.inet.tcp.msl: 15000 -> 1000

      Run siege.config to create the ~/.siegerc config file.
    EOS
  end

  test do
    system "#{bin}/siege", "--concurrent=1", "--reps=1", "https://www.google.com/"
  end
end
