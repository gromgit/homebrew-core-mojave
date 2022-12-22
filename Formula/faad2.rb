class Faad2 < Formula
  desc "ISO AAC audio decoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faad2/archive/refs/tags/2.10.1.tar.gz"
  sha256 "4c16c71295ca0cbf7c3dfe98eb11d8fa8d0ac3042e41604cfd6cc11a408cf264"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/faad2"
    sha256 cellar: :any, mojave: "899a0e87de519b4b857af86997ad288c39aa8750a854f64f478a75a86d0aff3b"
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
