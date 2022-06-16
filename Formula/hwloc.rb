class Hwloc < Formula
  desc "Portable abstraction of the hierarchical topology of modern architectures"
  homepage "https://www.open-mpi.org/projects/hwloc/"
  url "https://download.open-mpi.org/release/hwloc/v2.7/hwloc-2.7.1.tar.bz2"
  sha256 "0d4e1d36c3a72c5d61901bfd477337f5a4c7e0a975da57165237d00e35ef528d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.mail-archive.com/hwloc-announce@lists.open-mpi.org/"
    regex(/[\s,>]v?(\d+(?:\.\d+)+)(?:\s*?,|\s*?released)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hwloc"
    sha256 cellar: :any, mojave: "d291295dee43e78ec02a6bcc67e5bbd55d551399076188dc17357690cfa7f7c2"
  end

  head do
    url "https://github.com/open-mpi/hwloc.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-cairo",
                          "--without-x"
    system "make", "install"

    pkgshare.install "tests"

    # remove homebrew shims directory references
    rm Dir[pkgshare/"tests/**/Makefile"]
  end

  test do
    system ENV.cc, pkgshare/"tests/hwloc/hwloc_groups.c", "-I#{include}",
                   "-L#{lib}", "-lhwloc", "-o", "test"
    system "./test"
  end
end
