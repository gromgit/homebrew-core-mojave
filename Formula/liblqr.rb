class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  license "LGPL-3.0"
  revision 1
  head "https://github.com/carlobaldassi/liblqr.git", branch: "master"

  stable do
    url "https://github.com/carlobaldassi/liblqr/archive/v0.4.2.tar.gz"
    sha256 "1019a2d91f3935f1f817eb204a51ec977a060d39704c6dafa183b110fd6280b0"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
      sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
    end
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liblqr"
    rebuild 2
    sha256 cellar: :any, mojave: "3d69ddb1234403f986452994601e016a71713feabf03361e15a5b22e24e63f26"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
