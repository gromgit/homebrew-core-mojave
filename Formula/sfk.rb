class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/1.9.8.2/sfk-1.9.8.tar.gz"
  version "1.9.8.2"
  sha256 "051e6b81d9da348f19de906b6696882978d8b2c360b01d5447c5d4664aefe40c"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sfk"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "aaa8a990e053aa21797536cc83f4813daf86257fd8c3be1442aa1b1d5cf6dfdc"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sfk", "ip"
  end
end
