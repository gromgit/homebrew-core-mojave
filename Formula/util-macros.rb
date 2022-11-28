class UtilMacros < Formula
  desc "X.Org: Set of autoconf macros used to build other xorg packages"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/util/util-macros-1.19.3.tar.bz2"
  sha256 "0f812e6e9d2786ba8f54b960ee563c0663ddbe2434bf24ff193f5feab1f31971"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/util-macros"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "37755208d3543eba393850f25bbc8d57bb8bfe66dedcc6e1ad0168eb750f0821"
  end

  depends_on "pkg-config" => :test

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "xorg-macros"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
