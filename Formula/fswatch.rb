class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.17.1/fswatch-1.17.1.tar.gz"
  sha256 "c38e341c567f5f16bfa64b72fc48bba5e93873d8572522e670e6f320bbc2122f"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fswatch"
    rebuild 1
    sha256 mojave: "9f5aec131fc9cd1eaddb6196180523e85d4f1d39ff4e1db2bfa6b286643844c2"
  end

  def install
    ENV.cxx11
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"fswatch", "-h"
  end
end
