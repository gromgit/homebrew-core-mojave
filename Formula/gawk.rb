class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.1.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.1.1.tar.xz"
  sha256 "d87629386e894bbea11a5e00515fc909dc9b7249529dad9e6a3a2c77085f7ea2"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gawk"
    rebuild 3
    sha256 mojave: "405aa97030fad38a8827b08ed93974750dc5d4d62f64558b568ce78e11d8e19b"
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  conflicts_with "awk",
    because: "both install an `awk` executable"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-libsigsegv-prefix"

    system "make"
    if which "cmp"
      system "make", "check"
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    libexec.install_symlink "gnuman" => "man"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
