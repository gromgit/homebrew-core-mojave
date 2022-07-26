class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/binutils"
    rebuild 1
    sha256 mojave: "bab93d1762c0a6b6833b4ee793ef82e53c7b7296baa423fdb2be54f2dcb28662"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  uses_from_macos "zlib"

  on_linux do
    depends_on "glibc@2.13" => :build
    depends_on "linux-headers@4.4" => :build
  end

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-deterministic-archives",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}",
      "--disable-werror",
      "--enable-interwork",
      "--enable-multilib",
      "--enable-64-bit-bfd",
      "--enable-plugins",
      "--enable-targets=all",
      "--with-system-zlib",
      "--disable-nls",
      "--disable-gold",
    ]
    system "./configure", *args
    # Pass MAKEINFO=true to disable generation of HTML documentation.
    # This avoids a build time dependency on texinfo.
    make_args = OS.mac? ? [] : ["MAKEINFO=true"]
    system "make", *make_args
    system "make", "install", *make_args

    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      # Reduce the size of the bottle.
      system "strip", *bin.children, *lib.glob("*.a")
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
