class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-11.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-11.2.tar.xz"
  sha256 "1497c36a71881b8671a9a84a0ee40faab788ca30d7ba19d8463c3cc787152e32"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gdb"
    rebuild 2
    sha256 mojave: "c737a6242882337423783707096d618e1eb89e2e0a0201cf6ad2fa449f3fb722"
  end

  depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  depends_on "gmp"
  depends_on "python@3.10"
  depends_on "xz" # required for lzma support

  uses_from_macos "texinfo" => :build
  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "guile"
  end

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --enable-targets=all
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.10"].opt_bin}/python3
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb", "maybe-install-gdbserver"
    end
  end

  def caveats
    <<~EOS
      gdb requires special privileges to access Mach ports.
      You will need to codesign the binary. For instructions, see:

        https://sourceware.org/gdb/wiki/PermissionsDarwin
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
