class M4 < Formula
  desc "Macro processing language"
  homepage "https://www.gnu.org/software/m4"
  url "https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.xz"
  mirror "https://ftpmirror.gnu.org/m4/m4-1.4.19.tar.xz"
  sha256 "63aede5c6d33b6d9b13511cd0be2cac046f2e70fd0a07aa9573a04a82783af96"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/m4"
    rebuild 2
    sha256 mojave: "3b71da60e60afd42b34fd6e01b4f46885df969eb9dd1d501230d3ebfc559e591"
  end

  keg_only :provided_by_macos

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Homebrew",
      pipe_output("#{bin}/m4", "define(TEST, Homebrew)\nTEST\n")
  end
end
