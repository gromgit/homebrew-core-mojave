class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.02/suite3270-4.2ga4-src.tgz"
  sha256 "6a89ebdc7817bc204f79ebcdc6b5e7fef8c19aedfbc80284fedc647caa086790"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/x3270"
    sha256 mojave: "3bad1fb8eeca0c51b69f8821765a7f63f6f432c63515ac0cf2d868fca844bed8"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  # Apply patch on 4.2ga4. Remove after next release
  # https://github.com/pmattes/x3270/issues/36
  patch do
    url "https://github.com/pmattes/x3270/commit/80168fbc69544fee00517fb5b14bc662501929b8.patch?full_index=1"
    sha256 "a1a00c9396e565879e3cb5ff230861c914ebdf82e44911dd2799c43e2e2ccfad"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
