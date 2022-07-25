class Ivtools < Formula
  desc "X11 vector graphic servers"
  homepage "https://github.com/vectaport/ivtools"
  url "https://github.com/vectaport/ivtools/archive/refs/tags/ivtools-2.0.11d.tar.gz"
  sha256 "8c6fe536dff923f7819b4210a706f0abe721e13db8a844395048ded484fb2437"
  license "MIT"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ivtools"
    sha256 mojave: "b02d5470eb51e72a2eaf9f9b935504f5bdb1f4afc058b798c75703feecacd23a"
  end

  depends_on "ace"
  depends_on "libx11"
  depends_on "libxext"

  def install
    cp "Makefile.orig", "Makefile"
    ace = Formula["ace"]
    args = %W[--mandir=#{man} --with-ace=#{ace.opt_include} --with-ace-libs=#{ace.opt_lib}]
    system "./configure", *std_configure_args, *args
    system "make"
    system "make", "install"

    # Conflicts with dialog
    mv man3/"Dialog.3", man3/"Dialog_ivtools.3"

    # Delete unneeded symlink to libACE on Linux which conflicts with ace.
    rm lib/"libACE.so" unless OS.mac?
  end

  test do
    system "#{bin}/comterp", "exit(0)"
  end
end
