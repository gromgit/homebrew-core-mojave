class Uudeview < Formula
  desc "Smart multi-file multi-part decoder"
  homepage "http://www.fpx.de/fp/Software/UUDeview/"
  url "http://www.fpx.de/fp/Software/UUDeview/download/uudeview-0.5.20.tar.gz"
  sha256 "e49a510ddf272022af204e96605bd454bb53da0b3fe0be437115768710dae435"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?uudeview[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uudeview"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "0e0dda71ad229d08f7385f748c129ea8ed9d9149b84ef0afb7df149f31ac822a"
  end

  # Fix function signatures (for clang)
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/19da78c/uudeview/inews.c.patch"
    sha256 "4bdf357ede31abc17b1fbfdc230051f0c2beb9bb8805872bd66e40989f686d7b"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-tcl"
    system "make", "install"
    # uudeview provides the public library libuu, but no way to install it.
    # Since the package is unsupported, upstream changes are unlikely to occur.
    # Install the library and headers manually for now.
    lib.install "uulib/libuu.a"
    include.install "uulib/uudeview.h"
  end

  test do
    system "#{bin}/uudeview", "-V"
  end
end
