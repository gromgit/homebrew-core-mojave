class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faad2/archive/refs/tags/2_10_0.tar.gz"
  sha256 "0c6d9636c96f95c7d736f097d418829ced8ec6dbd899cc6cc82b728480a84bfb"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/faad2"
    rebuild 2
    sha256 cellar: :any, mojave: "a8a8ec97c8b4844100a13568334a0d78286a5dcf6bde98bac8247146cd3f77c3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "infile.mp4", shell_output("#{bin}/faad -h", 1)
  end
end
