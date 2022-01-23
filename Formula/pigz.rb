class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.7.tar.gz"
  sha256 "b4c9e60344a08d5db37ca7ad00a5b2c76ccb9556354b722d56d55ca7e8b1c707"
  license "Zlib"

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pigz"
    sha256 cellar: :any_skip_relocation, mojave: "caff530c18cb771c35e83ba43f6dfe8fafac5072345aae61b853b1270c770862"
  end

  uses_from_macos "zlib"

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _deflatePending
    # Reported 8 Dec 2016 to madler at alumni.caltech.edu
    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "pigz.c", "ZLIB_VERNUM >= 0x1260", "ZLIB_VERNUM >= 0x9999"
    end

    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert (testpath/"example.gz").file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1024k", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
