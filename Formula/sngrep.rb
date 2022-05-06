class Sngrep < Formula
  desc "Command-line tool for displaying SIP calls message flows"
  homepage "https://github.com/irontec/sngrep"
  url "https://github.com/irontec/sngrep/archive/v1.5.0.tar.gz"
  sha256 "c41620c02982fe87a443ccc795cc8c7fe7cf3d55338b8723f345b685bc153f4e"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sngrep"
    sha256 mojave: "18e0f76749e651415f99cbbfe0ea75d2b514b03dc3aef51d98ba4ed163ec2374"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ncurses" if DevelopmentTools.clang_build_version >= 1000
  depends_on "openssl@1.1"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  def install
    ENV.append_to_cflags "-I#{Formula["ncurses"].opt_include}/ncursesw" if OS.linux?

    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"sngrep", "-NI", test_fixtures("test.pcap")
  end
end
