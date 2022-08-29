class Fio < Formula
  desc "I/O benchmark and stress test"
  homepage "https://github.com/axboe/fio"
  url "https://github.com/axboe/fio/archive/fio-3.31.tar.gz"
  sha256 "077100819a243d0e00f232eb7c53fe1d30f4c54fba4d82847d5747eae1d255ab"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^fio[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fio"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8ea12cd8eef7a5557102b5ccff5c93fc1d8af60ef190304d3317ee585f05acab"
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
