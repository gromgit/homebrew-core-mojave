class Pce < Formula
  desc "PC emulator"
  homepage "http://www.hampa.ch/pce/"
  revision 3

  # TODO: Remove `-fcommon` workaround and switch to `sdl2` on next release
  stable do
    url "http://www.hampa.ch/pub/pce/pce-0.2.2.tar.gz"
    sha256 "a8c0560fcbf0cc154c8f5012186f3d3952afdbd144b419124c09a56f9baab999"
    depends_on "sdl12-compat"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pce"
    sha256 cellar: :any, mojave: "c67aa89af84c793e9d705a329ea0757514977decb5b3757e4de4a9f4c52121ee"
  end

  head do
    url "git://git.hampa.ch/pce.git", branch: "master"
    depends_on "sdl2"
  end

  depends_on "readline"

  on_high_sierra :or_newer do
    depends_on "nasm" => :build
  end

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # src/cpu/e68000/e68000.a(e68000.o):(.bss+0x0): multiple definition of `e68_ea_tab'
    # TODO: Remove in the next release.
    ENV.append_to_cflags "-fcommon" if OS.linux? && build.stable?

    system "./configure", *std_configure_args,
                          "--without-x",
                          "--enable-readline"
    system "make"

    # We need to run 'make install' without parallelization, because
    # of a race that may cause the 'install' utility to fail when
    # two instances concurrently create the same parent directories.
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system bin/"pce-ibmpc", "-V"
  end
end
