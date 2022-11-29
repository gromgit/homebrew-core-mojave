class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.33.tar.gz"
  sha256 "f48b2547313ffd1799c58c6a170175176131bbd42bc847b5650784eaf6d914b3"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fio"
    sha256 cellar: :any_skip_relocation, mojave: "9b2513aa278abba93e50489aa8596f342fc3a299f566936f71a50a29951add81"
  end

  uses_from_macos "zlib"

  def install
    system "./configure"
    # fio's CFLAGS passes vital stuff around, and crushing it will break the build
    system "make", "prefix=#{prefix}",
                   "mandir=#{man}",
                   "sharedir=#{share}",
                   "CC=#{ENV.cc}",
                   "V=true", # get normal verbose output from fio's makefile
                   "install"
  end

  test do
    system "#{bin}/fio", "--parse-only"
  end
end
