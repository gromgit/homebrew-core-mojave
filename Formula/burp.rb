class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"
  license "AGPL-3.0-only" => { with: "openvpn-openssl-exception" }

  stable do
    url "https://github.com/grke/burp/releases/download/2.4.0/burp-2.4.0.tar.bz2"
    sha256 "1f88d325f59c6191908d13ac764db5ee56b478fbea30244ae839383b9f9d2832"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash/archive/refs/tags/v2.3.0.tar.gz"
      sha256 "e10382ab75518bad8319eb922ad04f907cb20cccb451a3aa980c9d005e661acc"
    end
  end

  livecheck do
    url "https://burp.grke.org/download.html"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >].*?:\s*Stable}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/burp"
    sha256 mojave: "1f3366de9b6a5617884984b9b3481e257f3a2c0cd111f0d50ddd1a251176408c"
  end

  head do
    url "https://github.com/grke/burp.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git", branch: "master"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "librsync"
  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    resource("uthash").stage do
      (buildpath/"uthash/include").install "src/uthash.h"
    end

    ENV.prepend "CPPFLAGS", "-I#{buildpath}/uthash/include"

    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}"

    system "make", "install-all"
  end

  def post_install
    (var/"run").mkpath
    (var/"spool/burp").mkpath
  end

  def caveats
    <<~EOS
      Before installing the launchd entry you should configure your burp client in
        #{etc}/burp/burp.conf
    EOS
  end

  plist_options startup: true

  service do
    run [opt_bin/"burp", "-a", "t"]
    run_type :interval
    keep_alive false
    interval 1200
    working_dir HOMEBREW_PREFIX
  end

  test do
    system bin/"burp", "-V"
  end
end
