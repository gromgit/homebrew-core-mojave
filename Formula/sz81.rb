class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "https://sz81.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  license "GPL-2.0"
  revision 1
  head "https://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sz81"
    sha256 mojave: "b4d6de29c81e463d1ed0ba946d53dff926a8c772e14ac39c328383ee159e8d30"
  end

  depends_on "sdl12-compat"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # /usr/bin/ld: common.o:(.bss+0x127e0): multiple definition of `sdl_zx80rom'
    ENV.append_to_cflags "-fcommon" if OS.linux?

    args = %W[
      PREFIX=#{prefix}
      BINDIR=#{bin}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    # Disable test on Linux because it fails with this error:
    # sdl_init: Cannot initialise SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "sz81 #{version} -", shell_output("#{bin}/sz81 -h", 1)
  end
end
