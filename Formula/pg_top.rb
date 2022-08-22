class PgTop < Formula
  desc "Monitor PostgreSQL processes"
  homepage "https://pg_top.gitlab.io"
  url "https://ftp.postgresql.org/pub/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  mirror "https://mirrorservice.org/sites/ftp.postgresql.org/projects/pgFoundry/ptop/pg_top/3.7.0/pg_top-3.7.0.tar.bz2"
  sha256 "c48d726e8cd778712e712373a428086d95e2b29932e545ff2a948d043de5a6a2"
  revision 4

  # 4.0.0 is out, but unfortunatley no longer supports OS/X.  Therefore
  # we only look for the latest 3.x release until upstream adds OS/X support back.
  livecheck do
    url "https://gitlab.com/pg_top/pg_top.git"
    regex(/^v?(3(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pg_top"
    sha256 cellar: :any, mojave: "08f13a63e6a04d6ba215720539061472c45d0c8be2f534a227ac9ac08d3c529e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libpq"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-postgresql=#{Formula["libpq"].opt_prefix}"
    (buildpath/"config.h").append_lines "#define HAVE_DECL_STRLCPY 1"
    # On modern OS/X [v]snprinf() are macros that optionally add some security checks
    # In c.h this package provides their own declaration of these assuming they're
    # normal functions.  This collides with macro expansion badly but since we don't
    # need the declarations anyway just change the string to something harmless:
    inreplace "c.h", "snprintf", "unneeded_declaration_of_snprintf"
    # This file uses "vm_stats" as a symbol name which conflicts with vm_stats()
    # function in the SDK:
    inreplace "machine/m_macosx.c", "vm_stats", "vm_stats_data"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pg_top -V")
  end
end
