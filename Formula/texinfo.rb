class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftp.gnu.org/gnu/texinfo/texinfo-7.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/texinfo/texinfo-7.0.tar.xz"
  sha256 "20744b82531ce7a04d8cee34b07143ad59777612c3695d5855f29fba40fbe3e0"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/texinfo"
    rebuild 1
    sha256 mojave: "bc5cd25fe8b17c4f693ef8232ac95aaba9c837cb098c4cb91ef4aa9a0a0a499c"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  # texinfo has been removed from macOS Ventura.
  on_monterey :or_older do
    keg_only :provided_by_macos
  end

  on_system :linux, macos: :high_sierra_or_older do
    depends_on "gettext"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-install-warnings",
                          "--prefix=#{prefix}"
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS
    system "#{bin}/makeinfo", "test.texinfo"
    assert_match "Hello World!", File.read("test.info")
  end
end
