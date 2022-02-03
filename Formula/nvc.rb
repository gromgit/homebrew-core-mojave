class Nvc < Formula
  desc "VHDL compiler and simulator"
  homepage "https://github.com/nickg/nvc"
  url "https://github.com/nickg/nvc/releases/download/r1.6.0/nvc-1.6.0.tar.gz"
  sha256 "1e93e461b53261254b123ed0a88ba72316ed61d9985bb4439a473bd08b81da88"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nvc"
    sha256 mojave: "3f1713d1f5ee1984aca76aeabc6d8679fc1c8632e172141a6fa15de5c36b0805"
  end

  head do
    url "https://github.com/nickg/nvc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "llvm"

  uses_from_macos "flex" => :build

  fails_with gcc: "5" # LLVM is built with GCC

  resource "homebrew-test" do
    url "https://github.com/suoto/vim-hdl-examples.git",
        revision: "fcb93c287c8e4af7cc30dc3e5758b12ee4f7ed9b"
  end

  def install
    system "./autogen.sh" if build.head?
    # Avoid hardcoding path to the `ld` shim.
    inreplace "configure", "\\\"$linker_path\\\"", "\\\"ld\\\"" if OS.linux?
    system "./configure", "--with-llvm=#{Formula["llvm"].opt_bin}/llvm-config",
                          "--prefix=#{prefix}",
                          "--with-system-cc=#{ENV.cc}",
                          "--enable-vhpi",
                          "--disable-silent-rules"
    ENV.deparallelize
    system "make", "V=1"
    system "make", "V=1", "install"
  end

  test do
    resource("homebrew-test").stage testpath
    system "#{bin}/nvc", "-a", "#{testpath}/basic_library/very_common_pkg.vhd"
  end
end
