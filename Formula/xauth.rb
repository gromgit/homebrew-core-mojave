class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.1.tar.bz2"
  sha256 "164ea0a29137b284a47b886ef2affcb0a74733bf3aad04f9b106b1a6c82ebd92"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xauth"
    sha256 cellar: :any, mojave: "ada651e36c51e44d58bba99a9aaa93c874d8eb4bb2d98cfec748c6cf6662e05c"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "libx11"
  depends_on "libxau"
  depends_on "libxext"
  depends_on "libxmu"

  on_linux do
    depends_on "libxcb"
    depends_on "libxdmcp"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-unix-transport
      --enable-tcp-transport
      --enable-ipv6
      --enable-local-transport
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "unable to open display", shell_output("xauth generate :0 2>&1", 1)
  end
end
