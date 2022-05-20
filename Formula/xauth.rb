class Xauth < Formula
  desc "X.Org Applications: xauth"
  homepage "https://www.x.org/"
  url "https://www.x.org/pub/individual/app/xauth-1.1.2.tar.xz"
  sha256 "78ba6afd19536ced1dddb3276cba6e9555a211b468a06f95f6a97c62ff8ee200"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xauth"
    sha256 cellar: :any, mojave: "e2861fe55048bb984b96f5f628b4729b05f7a05580faf368c1bcaba9d085fe29"
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
