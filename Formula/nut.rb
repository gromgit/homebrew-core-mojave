class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "https://networkupstools.org/"
  license "GPL-2.0-or-later"

  stable do
    url "https://github.com/networkupstools/nut/releases/download/v2.8.0/nut-2.8.0.tar.gz"
    sha256 "c3e5a708da797b7c70b653d37b1206a000fcb503b85519fe4cdf6353f792bfe5"

    # fix build failure
    # remove in next release
    patch do
      url "https://github.com/networkupstools/nut/commit/9e6d3c79a4c0ed71c25fdfd350402bb2e78e42e8.patch?full_index=1"
      sha256 "39472a04f1963a297713381a3a17e57183c1143a6602c194ca3016244caa6a9f"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nut"
    sha256 mojave: "93e730ebf8c6f4b98d253dce26e493544f6bd2c8c2d557b181bd63e97aa7bb06"
  end

  head do
    url "https://github.com/networkupstools/nut.git", branch: "master"
    depends_on "asciidoc" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"
  depends_on "openssl@1.1"

  conflicts_with "rhino", because: "both install `rhino` binaries"

  def install
    if build.head?
      ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
      system "./autogen.sh"
    else
      # Regenerate configure, due to patch applied
      system "autoreconf", "-i"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}/nut
      --with-statepath=#{var}/state/ups
      --with-pidpath=#{var}/run
      --with-systemdtmpfilesdir=#{pkgshare}
      --with-openssl
      --with-serial
      --with-usb
      --without-avahi
      --without-cgi
      --without-dev
      --without-doc
      --without-ipmi
      --without-libltdl
      --without-neon
      --without-nss
      --without-powerman
      --without-snmp
      --without-wrap
    ]
    args << if OS.mac?
      "--with-macosx_ups"
    else
      "--with-udev-dir=#{lib}/udev"
    end

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"state/ups").mkpath
    (var/"run").mkpath
  end

  service do
    run [opt_sbin/"upsmon", "-D"]
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
