class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://invisible-island.net/ncurses/announce.html"
  url "https://ftp.gnu.org/gnu/ncurses/ncurses-6.3.tar.gz"
  mirror "https://invisible-mirror.net/archives/ncurses/ncurses-6.3.tar.gz"
  mirror "ftp://ftp.invisible-island.net/ncurses/ncurses-6.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/ncurses/ncurses-6.3.tar.gz"
  sha256 "97fc51ac2b085d4cde31ef4d2c3122c21abc217e9090a43a30fc5ec21684e059"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ncurses"
    rebuild 2
    sha256 mojave: "d349d6d9ae8a28a6fa763d897d8b63f83ef4ecbf82563caa1827d19d1d4681f7"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

  on_linux do
    depends_on "gpatch" => :build
  end

  def install
    # Workaround for
    # macOS: mkdir: /usr/lib/pkgconfig:/opt/homebrew/Library/Homebrew/os/mac/pkgconfig/12: Operation not permitted
    # Linux: configure: error: expected a pathname, not ""
    (lib/"pkgconfig").mkpath

    args = [
      "--prefix=#{prefix}",
      "--enable-pc-files",
      "--with-pkg-config-libdir=#{lib}/pkgconfig",
      "--enable-sigwinch",
      "--enable-symlinks",
      "--enable-widec",
      "--with-shared",
      "--with-cxx-shared",
      "--with-gpm=no",
      "--without-ada",
    ]
    args << "--with-terminfo-dirs=#{share}/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo" if OS.linux?

    system "./configure", *args
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.major.to_s

    %w[form menu ncurses panel ncurses++].each do |name|
      lib.install_symlink shared_library("lib#{name}w", major) => shared_library("lib#{name}")
      lib.install_symlink shared_library("lib#{name}w", major) => shared_library("lib#{name}", major)
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses.a" => "libcurses.a"
    lib.install_symlink shared_library("libncurses") => shared_library("libcurses")
    on_linux do
      # libtermcap and libtinfo are provided by ncurses and have the
      # same api. Help some older packages to find these dependencies.
      # https://bugs.centos.org/view.php?id=11423
      # https://bugs.launchpad.net/ubuntu/+source/ncurses/+bug/259139
      lib.install_symlink "libncurses.so" => "libtermcap.so"
      lib.install_symlink "libncurses.so" => "libtinfo.so"
    end

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"
    (lib/"pkgconfig").install_symlink "formw.pc" => "form.pc"
    (lib/"pkgconfig").install_symlink "menuw.pc" => "menu.pc"
    (lib/"pkgconfig").install_symlink "panelw.pc" => "panel.pc"

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink "ncursesw" => "ncurses"
    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    ENV["TERM"] = "xterm"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/keynames"
    system testpath/"test/bin/test_arrays"
    system testpath/"test/bin/test_vidputs"
  end
end
