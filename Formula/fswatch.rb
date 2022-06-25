class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https://github.com/emcrisostomo/fswatch"
  url "https://github.com/emcrisostomo/fswatch/releases/download/1.17.0/fswatch-1.17.0.tar.gz"
  sha256 "988d9fca774eb9b2d1b3575ef56c5ce7fdcc718dbabaf727178651eac11bdabc"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fswatch"
    sha256 mojave: "3c5ad7cf593f47b908b6bbe1bf68368bbdd68ca958440c6b21545f31c500e821"
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
