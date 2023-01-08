class GnuUnits < Formula
  desc "GNU unit conversion tool"
  homepage "https://www.gnu.org/software/units/"
  url "https://ftp.gnu.org/gnu/units/units-2.22.tar.gz"
  mirror "https://ftpmirror.gnu.org/units/units-2.22.tar.gz"
  sha256 "5d13e1207721fe7726d906ba1d92dc0eddaa9fc26759ed22e3b8d1a793125848"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gnu-units"
    rebuild 1
    sha256 mojave: "3d688703d211e8a9843810f1754345cd9149f1cc6d95ab6e493d679d39b4ccc7"
  end

  depends_on "readline"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-installed-readline
    ]

    args << "--program-prefix=g" if OS.mac?
    system "./configure", *args
    system "make", "install"

    if OS.mac?
      (libexec/"gnubin").install_symlink bin/"gunits" => "units"
      (libexec/"gnubin").install_symlink bin/"gunits_cur" => "units_cur"
      (libexec/"gnuman/man1").install_symlink man1/"gunits.1" => "units.1"
    end
    libexec.install_symlink "gnuman" => "man"
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    if OS.mac?
      assert_equal "* 18288", shell_output("#{bin}/gunits '600 feet' 'cm' -1").strip
      assert_equal "* 18288", shell_output("#{opt_libexec}/gnubin/units '600 feet' 'cm' -1").strip
    else
      assert_equal "* 18288", shell_output("#{bin}/units '600 feet' 'cm' -1").strip
    end
  end
end
