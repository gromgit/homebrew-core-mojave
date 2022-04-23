class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.14.1/libfabric-1.14.1.tar.bz2"
  sha256 "6cfabb94bca8e419d9015212506f5a367d077c5b11e94b9f57997ec6ca3d8aed"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libfabric"
    sha256 cellar: :any, mojave: "b220990dbc2b9cf67c96cda00d86f8bcc0c2be266f3e8e9226ac2c325cc0e28b"
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
