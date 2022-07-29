class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gauche"
    sha256 mojave: "606b0b078c059b05a0ab1980b7d185c704504328a1eec579824498734f72aed9"
  end

  depends_on "mbedtls"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--enable-multibyte=utf-8"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/gosh -V")
    assert_match "Gauche scheme shell, version #{version}", output
  end
end
