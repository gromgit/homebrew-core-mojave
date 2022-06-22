class Swtpm < Formula
  desc "Software TPM Emulator based on libtpms"
  homepage "https://github.com/stefanberger/swtpm"
  url "https://github.com/stefanberger/swtpm/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "e856d1f5842fb3335164f02f2c545dd329efbc3416db20b7a327e991a4cd49c8"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/swtpm"
    sha256 mojave: "cbfe8e9ce83318094309aa4a0ae4cbcbdbbb1092b4a8847c05a127eb7b008b92"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libtool" => :build
  depends_on "socat" => :build
  depends_on "gnutls"
  depends_on "json-glib"
  depends_on "libtasn1"
  depends_on "libtpms"
  depends_on "openssl@3"

  uses_from_macos "expect"

  on_linux do
    depends_on "libseccomp"
    depends_on "net-tools"
  end

  def install
    ENV.append "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib}" if OS.linux?

    system "./autogen.sh", *std_configure_args, "--with-openssl"
    system "make"
    system "make", "install"
  end

  test do
    port = free_port
    pid = fork do
      system bin/"swtpm", "socket", "--ctrl", "type=tcp,port=#{port}"
    end
    sleep 2
    system bin/"swtpm_ioctl", "--tcp", "127.0.0.1:#{port}", "-s"
  ensure
    Process.wait pid
  end
end
