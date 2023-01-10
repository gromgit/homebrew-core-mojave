class Libzip < Formula
  desc "C library for reading, creating, and modifying zip archives"
  homepage "https://libzip.org/"
  url "https://libzip.org/download/libzip-1.9.2.tar.xz", using: :homebrew_curl
  sha256 "c93e9852b7b2dc931197831438fee5295976ee0ba24f8524a8907be5c2ba5937"
  license "BSD-3-Clause"

  livecheck do
    url "https://libzip.org/download/"
    regex(/href=.*?libzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libzip"
    rebuild 1
    sha256 cellar: :any, mojave: "a5e8c62e3a911ef7e2b88a6e13635fb357b21d43495f0d661707b946b0b21744"
  end

  depends_on "cmake" => :build
  depends_on "zstd"

  uses_from_macos "zip" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@1.1"
  end

  conflicts_with "libtcod", "minizip-ng",
    because: "libtcod, libzip and minizip-ng install a `zip.h` header"

  def install
    crypto_args = %w[
      -DENABLE_GNUTLS=OFF
      -DENABLE_MBEDTLS=OFF
    ]
    crypto_args << "-DENABLE_OPENSSL=OFF" if OS.mac? # Use CommonCrypto instead.
    system "cmake", ".", *std_cmake_args,
                         *crypto_args,
                         "-DBUILD_REGRESS=OFF",
                         "-DBUILD_EXAMPLES=OFF"
    system "make", "install"
  end

  test do
    touch "file1"
    system "zip", "file1.zip", "file1"
    touch "file2"
    system "zip", "file2.zip", "file1", "file2"
    assert_match(/\+.*file2/, shell_output("#{bin}/zipcmp -v file1.zip file2.zip", 1))
  end
end
