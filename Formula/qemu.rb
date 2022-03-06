class Qemu < Formula
  desc "Emulator for x86 and PowerPC"
  homepage "https://www.qemu.org/"
  url "https://download.qemu.org/qemu-6.2.0.tar.xz"
  sha256 "68e15d8e45ac56326e0b9a4afa8b49a3dfe8aba3488221d098c84698bca65b45"
  license "GPL-2.0-only"
  head "https://git.qemu.org/git/qemu.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qemu"
    rebuild 2
    sha256 mojave: "97941682c7f5d8448681be6d78570f868bff938c2509a3067640a7918ca18bcf"
  end

  depends_on "libtool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "glib"
  depends_on "gnutls"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on "libssh"
  depends_on "libusb"
  depends_on "lzo"
  depends_on "ncurses"
  depends_on "nettle"
  depends_on "pixman"
  depends_on "snappy"
  depends_on "vde"

  on_linux do
    depends_on "gcc"
    depends_on "gtk+3"
  end

  fails_with gcc: "5"

  # 820KB floppy disk image file of FreeDOS 1.2, used to test QEMU
  resource "homebrew-test-image" do
    url "https://www.ibiblio.org/pub/micro/pc-stuff/freedos/files/distributions/1.2/official/FD12FLOPPY.zip"
    sha256 "81237c7b42dc0ffc8b32a2f5734e3480a3f9a470c50c14a9c4576a2561a35807"
  end

  def install
    ENV["LIBTOOL"] = "glibtool"

    args = %W[
      --prefix=#{prefix}
      --cc=#{ENV.cc}
      --host-cc=#{ENV.cc}
      --disable-bsd-user
      --disable-guest-agent
      --enable-curses
      --enable-libssh
      --enable-slirp=system
      --enable-vde
      --extra-cflags=-DNCURSES_WIDECHAR=1
      --disable-sdl
    ]
    # Sharing Samba directories in QEMU requires the samba.org smbd which is
    # incompatible with the macOS-provided version. This will lead to
    # silent runtime failures, so we set it to a Homebrew path in order to
    # obtain sensible runtime errors. This will also be compatible with
    # Samba installations from external taps.
    args << "--smbd=#{HOMEBREW_PREFIX}/sbin/samba-dot-org-smbd"

    args << "--disable-gtk" if OS.mac?
    args << "--enable-cocoa" if OS.mac?
    args << "--enable-gtk" if OS.linux?

    system "./configure", *args
    system "make", "V=1", "install"
  end

  test do
    expected = build.stable? ? version.to_s : "QEMU Project"
    assert_match expected, shell_output("#{bin}/qemu-system-aarch64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-alpha --version")
    assert_match expected, shell_output("#{bin}/qemu-system-arm --version")
    assert_match expected, shell_output("#{bin}/qemu-system-cris --version")
    assert_match expected, shell_output("#{bin}/qemu-system-hppa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-i386 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-m68k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblaze --version")
    assert_match expected, shell_output("#{bin}/qemu-system-microblazeel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mips64el --version")
    assert_match expected, shell_output("#{bin}/qemu-system-mipsel --version")
    assert_match expected, shell_output("#{bin}/qemu-system-nios2 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-or1k --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-ppc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv32 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-riscv64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-rx --version")
    assert_match expected, shell_output("#{bin}/qemu-system-s390x --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sh4eb --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc --version")
    assert_match expected, shell_output("#{bin}/qemu-system-sparc64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-tricore --version")
    assert_match expected, shell_output("#{bin}/qemu-system-x86_64 --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensa --version")
    assert_match expected, shell_output("#{bin}/qemu-system-xtensaeb --version")
    resource("homebrew-test-image").stage testpath
    assert_match "file format: raw", shell_output("#{bin}/qemu-img info FLOPPY.img")
  end
end
