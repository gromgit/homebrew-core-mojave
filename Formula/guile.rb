class Guile < Formula
  desc "GNU Ubiquitous Intelligent Language for Extensions"
  homepage "https://www.gnu.org/software/guile/"
  license "LGPL-3.0-or-later"
  revision 4

  stable do
    url "https://ftp.gnu.org/gnu/guile/guile-3.0.8.tar.xz"
    mirror "https://ftpmirror.gnu.org/guile/guile-3.0.8.tar.xz"
    sha256 "daa7060a56f2804e9b74c8d7e7fe8beed12b43aab2789a38585183fcc17b8a13"

    patch do
      # A patch to fix JIT on Apple Silicon is embedded below, this fixes:
      #   https://debbugs.gnu.org/cgi/bugreport.cgi?bug=44505
      # We should remove it from here once Guile 3.0.9 is released.
      on_macos do
        url "https://git.savannah.gnu.org/cgit/guile.git/patch/?id=3bdcc3668fd8f9a5b6c9a313ff8d70acb32b2a52"
        sha256 "3deeb4c01059615df97081e53056c76bcc465030aaaaf01f5941fbea4d16cb6f"
      end
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/guile"
    sha256 mojave: "29887455c454d1545ca0d3af7f5cf9fdbcfe1354c0ee2b0ccc2b3514bd645712"
  end

  head do
    url "https://git.savannah.gnu.org/git/guile.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    uses_from_macos "flex" => :build
  end

  # Remove with Guile 3.0.9 release.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build

  depends_on "gnu-sed" => :build
  depends_on "bdw-gc"
  depends_on "gmp"
  depends_on "libtool"
  depends_on "libunistring"
  depends_on "pkg-config" # guile-config is a wrapper around pkg-config.
  depends_on "readline"

  # Remove with Guile 3.0.9 release.
  uses_from_macos "flex" => :build

  uses_from_macos "gperf"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "libxcrypt"

  def install
    # Avoid superenv shim
    inreplace "meta/guile-config.in", "@PKG_CONFIG@", Formula["pkg-config"].opt_bin/"pkg-config"

    system "./autogen.sh" unless build.stable?

    # Remove with Guile 3.0.9 release.
    system "autoreconf", "-vif" if OS.mac? && build.stable?

    system "./configure", *std_configure_args,
                          "--with-libreadline-prefix=#{Formula["readline"].opt_prefix}",
                          "--with-libgmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--disable-nls"
    system "make", "install"

    # A really messed up workaround required on macOS --mkhl
    Pathname.glob("#{lib}/*.dylib") do |dylib|
      lib.install_symlink dylib.basename => "#{dylib.basename(".dylib")}.so"
    end

    # This is either a solid argument for guile including options for
    # --with-xyz-prefix= for libffi and bdw-gc or a solid argument for
    # Homebrew automatically removing Cellar paths from .pc files in favour
    # of opt_prefix usage everywhere.
    inreplace lib/"pkgconfig/guile-3.0.pc" do |s|
      s.gsub! Formula["bdw-gc"].prefix.realpath, Formula["bdw-gc"].opt_prefix
      s.gsub! Formula["libffi"].prefix.realpath, Formula["libffi"].opt_prefix if MacOS.version < :catalina
    end

    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.scm"]
  end

  def post_install
    # Create directories so installed modules can create links inside.
    (HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache").mkpath
    (HOMEBREW_PREFIX/"lib/guile/3.0/extensions").mkpath
    (HOMEBREW_PREFIX/"share/guile/site/3.0").mkpath
  end

  def caveats
    <<~EOS
      Guile libraries can now be installed here:
          Source files: #{HOMEBREW_PREFIX}/share/guile/site/3.0
        Compiled files: #{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache
            Extensions: #{HOMEBREW_PREFIX}/lib/guile/3.0/extensions

      Add the following to your .bashrc or equivalent:
        export GUILE_LOAD_PATH="#{HOMEBREW_PREFIX}/share/guile/site/3.0"
        export GUILE_LOAD_COMPILED_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/site-ccache"
        export GUILE_SYSTEM_EXTENSIONS_PATH="#{HOMEBREW_PREFIX}/lib/guile/3.0/extensions"
    EOS
  end

  test do
    hello = testpath/"hello.scm"
    hello.write <<~EOS
      (display "Hello World")
      (newline)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"

    system bin/"guile", hello
  end
end
