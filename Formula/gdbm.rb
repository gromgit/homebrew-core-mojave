class Gdbm < Formula
  desc "GNU database manager"
  homepage "https://www.gnu.org/software/gdbm/"
  url "https://ftp.gnu.org/gnu/gdbm/gdbm-1.23.tar.gz"
  mirror "https://ftpmirror.gnu.org/gdbm/gdbm-1.23.tar.gz"
  sha256 "74b1081d21fff13ae4bd7c16e5d6e504a4c26f7cde1dca0d963a484174bbcacd"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gdbm"
    rebuild 4
    sha256 mojave: "146461ed0286d06445af246f1bd70fc439ef46034fad890f6cdf0d0ce4fc7ec9"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # --enable-libgdbm-compat for dbm.h / gdbm-ndbm.h compatibility:
  #   https://www.gnu.org.ua/software/gdbm/manual/html_chapter/gdbm_19.html
  # Use --without-readline because readline detection is broken in 1.13
  # https://github.com/Homebrew/homebrew-core/pull/10903
  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-libgdbm-compat
      --without-readline
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    # Avoid conflicting with macOS SDK's ndbm.h.  Renaming to gdbm-ndbm.h
    # matches Debian's convention for gdbm's ndbm.h (libgdbm-compat-dev).
    mv include/"ndbm.h", include/"gdbm-ndbm.h"
  end

  test do
    pipe_output("#{bin}/gdbmtool --norc --newdb test", "store 1 2\nquit\n")
    assert_predicate testpath/"test", :exist?
    assert_match "2", pipe_output("#{bin}/gdbmtool --norc test", "fetch 1\nquit\n")
  end
end
