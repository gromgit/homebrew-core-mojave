class Qdae < Formula
  desc "Quick and Dirty Apricot Emulator"
  homepage "https://www.seasip.info/Unix/QDAE/"
  url "https://www.seasip.info/Unix/QDAE/qdae-0.0.10.tar.gz"
  sha256 "780752c37c9ec68dd0cd08bd6fe288a1028277e10f74ef405ca200770edb5227"
  license "GPL-2.0"
  revision 2

  livecheck do
    url :homepage
    regex(/href=.*?qdae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qdae"
    sha256 mojave: "f904b16366bcf2863e50f4bd996dd45820f2d3e35185269c9f2826a9044773d3"
  end

  deprecate! date: "2022-09-23", because: :unmaintained

  depends_on "sdl12-compat"

  uses_from_macos "libxml2"

  def install
    # Fix build failure with newer glibc:
    # /usr/bin/ld: ../lib/.libs/libdsk.a(drvlinux.o): in function `linux_open':
    # drvlinux.c:(.text+0x168): undefined reference to `major'
    # /usr/bin/ld: ../lib/.libs/libdsk.a(compress.o): in function `comp_open':
    # compress.c:(.text+0x268): undefined reference to `major'
    ENV.append_to_cflags "-include sys/sysmacros.h" if OS.linux?

    ENV.cxx11
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Data files are located in the following directory:
        #{share}/QDAE
    EOS
  end

  test do
    assert_predicate bin/"qdae", :executable?
  end
end
