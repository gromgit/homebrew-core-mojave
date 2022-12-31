class Minizip < Formula
  desc "C library for zip/unzip via zLib"
  homepage "https://www.winimage.com/zLibDll/minizip.html"
  url "https://zlib.net/zlib-1.2.13.tar.gz"
  mirror "https://downloads.sourceforge.net/project/libpng/zlib/1.2.13/zlib-1.2.13.tar.gz"
  sha256 "b3a24de97a8fdbc835b9833169501030b8977031bcb54b3b3ac13740f846ab30"
  license "Zlib"

  livecheck do
    formula "zlib"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/minizip"
    sha256 cellar: :any, mojave: "afd8c2ef4095468c36638d3548633d60b2ca6233f6708ffcc44a10510229a06f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "zlib"

  conflicts_with "minizip-ng",
    because: "both install a `libminizip.a` library"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    cd "contrib/minizip" do
      if OS.mac?
        # edits to statically link to libz.a
        inreplace "Makefile.am" do |s|
          s.sub! "-L$(zlib_top_builddir)", "$(zlib_top_builddir)/libz.a"
          s.sub! "-version-info 1:0:0 -lz", "-version-info 1:0:0"
          s.sub! "libminizip.la -lz", "libminizip.la"
        end
      end
      system "autoreconf", "-fi"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Minizip headers installed in 'minizip' subdirectory, since they conflict
      with the venerable 'unzip' library.
    EOS
  end
end
