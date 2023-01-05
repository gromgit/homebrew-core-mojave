class Flashrom < Formula
  desc "Identify, read, write, verify, and erase flash chips"
  homepage "https://flashrom.org/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://review.coreboot.org/flashrom.git", branch: "master"

  stable do
    url "https://download.flashrom.org/releases/flashrom-v1.2.tar.bz2"
    sha256 "e1f8d95881f5a4365dfe58776ce821dfcee0f138f75d0f44f8a3cd032d9ea42b"

    # Add https://github.com/flashrom/flashrom/pull/212, to allow flashrom to build on Apple Silicon
    patch do
      url "https://github.com/areese/flashrom/commit/0c7b279d78f95083b686f6b1d4ce0f7b91bf0fd0.patch?full_index=1"
      sha256 "9e1f54f7ae4e67b880df069b419835131f72d166b3893870746fff456b0b7225"
    end
  end

  livecheck do
    url "https://download.flashrom.org/releases/"
    regex(/href=.*?flashrom[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/flashrom"
    rebuild 1
    sha256 cellar: :any, mojave: "c93e1379dba6099bd81c94b23fb4cc36b3ed9b447a47158787478376267c3d7a"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"

  def install
    ENV["CONFIG_RAYER_SPI"] = "no"
    ENV["CONFIG_ENABLE_LIBPCI_PROGRAMMERS"] = "no"

    system "make", "DESTDIR=#{prefix}", "PREFIX=/", "install"
    mv sbin, bin
  end

  test do
    system bin/"flashrom", "--version"
  end
end
