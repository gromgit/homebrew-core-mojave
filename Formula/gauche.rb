class Gauche < Formula
  desc "R7RS Scheme implementation, developed to be a handy script interpreter"
  homepage "https://practical-scheme.net/gauche/"
  url "https://github.com/shirok/Gauche/releases/download/release0_9_12/Gauche-0.9.12.tgz"
  sha256 "b4ae64921b07a96661695ebd5aac0dec813d1a68e546a61609113d7843f5b617"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
    regex(/href=.*?Gauche[._-]v?(\d+(?:\.\d+)+(?:[._-]p\d+)?)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gauche"
    sha256 mojave: "c3b9693249528c9d87bad885ecf8b8dc8da1e8432b194a1b132b2d7f37f1c448"
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
