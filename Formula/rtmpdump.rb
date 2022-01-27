class Rtmpdump < Formula
  desc "Tool for downloading RTMP streaming media"
  homepage "https://rtmpdump.mplayerhq.hu/"
  url "https://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  mirror "http://deb.debian.org/debian/pool/main/r/rtmpdump/rtmpdump_2.4+20151223.gitfa8646d.1.orig.tar.gz"
  version "2.4+20151223"
  sha256 "5c032f5c8cc2937eb55a81a94effdfed3b0a0304b6376147b86f951e225e3ab5"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://git.ffmpeg.org/rtmpdump.git"

  livecheck do
    url "https://cdn-aws.deb.debian.org/debian/pool/main/r/rtmpdump/"
    regex(/href=.*?rtmpdump[._-]v?(\d+(?:[.+]\d+)+)[^"' >]*?\.orig\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rtmpdump"
    rebuild 1
    sha256 cellar: :any, mojave: "3ad1ffc4610aa26f9890e154046f3f9f171722be19f6fadc1caff3da8dc61998"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "flvstreamer", because: "both install 'rtmpsrv', 'rtmpsuck' and 'streams' binary"

  # Patch for OpenSSL 1.1 compatibility
  # Taken from https://github.com/JudgeZarbi/RTMPDump-OpenSSL-1.1
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rtmpdump/openssl-1.1.diff"
    sha256 "3c9167e642faa9a72c1789e7e0fb1ff66adb11d721da4bd92e648cb206c4a2bd"
  end

  def install
    ENV.deparallelize

    os = if OS.mac?
      "darwin"
    else
      "posix"
    end

    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=#{os}",
                   "prefix=#{prefix}",
                   "sbindir=#{bin}",
                   "install"
  end

  test do
    system "#{bin}/rtmpdump", "-h"
  end
end
