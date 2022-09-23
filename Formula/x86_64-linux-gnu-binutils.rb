class X8664LinuxGnuBinutils < Formula
  desc "GNU Binutils for x86_64-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.39.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.39.tar.xz"
  sha256 "645c25f563b8adc0a81dbd6a41cffbf4d37083a382e02d5d3df4f65c09516d00"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/x86_64-linux-gnu-binutils"
    rebuild 1
    sha256 mojave: "fc7c0658cc9931247d2a7559fbf00c2cbd5905b2e1eeb8c48bc8791e29d53a6d"
  end

  uses_from_macos "texinfo"

  on_linux do
    keg_only "it conflicts with `binutils`"
  end

  resource "homebrew-sysroot" do
    url "https://commondatastorage.googleapis.com/chrome-linux-sysroot/toolchain/2028cdaf24259d23adcff95393b8cc4f0eef714b/debian_bullseye_amd64_sysroot.tar.xz"
    sha256 "1be60e7c456abc590a613c64fab4eac7632c81ec6f22734a61b53669a4407346"
  end

  def install
    ENV.cxx11

    # Avoid build failure: https://sourceware.org/bugzilla/show_bug.cgi?id=23424
    ENV.append "CXXFLAGS", "-Wno-c++11-narrowing"

    target = "x86_64-linux-gnu"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--libdir=#{lib/target}",
                          "--infodir=#{info/target}",
                          "--disable-werror",
                          "--target=#{target}",
                          "--enable-gold=yes",
                          "--enable-ld=yes",
                          "--enable-interwork",
                          "--with-system-zlib",
                          "--disable-nls",
                          "--disable-gprofng" # Fails to build on Linux
    system "make"
    system "make", "install"
  end

  test do
    assert_match "f()", shell_output("#{bin}/x86_64-linux-gnu-c++filt _Z1fv")
    return if OS.linux?

    (testpath/"sysroot").install resource("homebrew-sysroot")
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() { printf("hello!\\n"); }
    EOS

    ENV.remove_macosxsdk
    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot", "-c", "hello.c"
    assert_match "main", shell_output("#{bin}/x86_64-linux-gnu-nm hello.o")

    system ENV.cc, "-v", "--target=x86_64-pc-linux-gnu", "--sysroot=#{testpath}/sysroot",
                   "-fuse-ld=#{bin}/x86_64-linux-gnu-ld", "hello.o", "-o", "hello"
    assert_match "ELF", shell_output("file ./hello")
    assert_match "libc.so", shell_output("#{bin}/x86_64-linux-gnu-readelf -d ./hello")
    system bin/"x86_64-linux-gnu-strip", "./hello"
  end
end
