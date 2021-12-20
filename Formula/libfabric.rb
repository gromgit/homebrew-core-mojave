class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.14.0/libfabric-1.14.0.tar.bz2"
  sha256 "fc261388848f3cff555bd653f5cb901f6b9485ad285e5c53328b13f0e69f749a"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libfabric"
    sha256 cellar: :any, mojave: "72a2d5a586a943333adaa7a40954d51ec754cf07a3f011eed512e1d28b369af5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  on_macos do
    conflicts_with "mpich", because: "both install `fabric.h`"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
