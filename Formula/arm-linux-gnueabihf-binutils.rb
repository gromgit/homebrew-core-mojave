class ArmLinuxGnueabihfBinutils < Formula
  desc "FSF/GNU binutils for cross-compiling to arm-linux"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arm-linux-gnueabihf-binutils"
    sha256 mojave: "8fa8b06beb246d2a878421fb31a58c958bbceff1732c7de2e45ebd308d44a99a"
  end

  uses_from_macos "texinfo"

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "arm-linux-gnueabihf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib}/#{target}",
                          "--infodir=#{info}/#{target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--disable-nls"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/arm-linux-gnueabihf-c++filt _Z1fv")
  end
end
