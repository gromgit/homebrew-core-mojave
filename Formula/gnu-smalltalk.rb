class GnuSmalltalk < Formula
  desc "Implementation of the Smalltalk language"
  homepage "https://www.gnu.org/software/smalltalk/"
  url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  license "GPL-2.0"
  revision 10
  head "https://github.com/gnu-smalltalk/smalltalk.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gnu-smalltalk"
    rebuild 1
    sha256 mojave: "ab4b5dc5a2eb437ea5f49d9047398e2a9c072bebf14bcfc9e9db9eb054ac86f4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "libsigsegv"
  depends_on "libtool"
  depends_on "readline"

  uses_from_macos "zip" => :build
  uses_from_macos "libffi", since: :catalina

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-lispdir=#{elisp}
      --disable-gtk
      --with-readline=#{Formula["readline"].opt_lib}
      --without-tcl
      --without-tk
      --without-x
    ]

    system "autoreconf", "-ivf"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    assert_match "0123456789", shell_output("#{bin}/gst #{path}")
  end
end
