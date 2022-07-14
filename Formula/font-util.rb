class FontUtil < Formula
  desc "X.Org: Font package creation/installation utilities"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/font/font-util-1.3.3.tar.xz"
  sha256 "e791c890779c40056ab63aaed5e031bb6e2890a98418ca09c534e6261a2eebd2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/font-util"
    sha256 cellar: :any_skip_relocation, mojave: "44118f071703b1c8068848c995bf10bfde0486c9d7208a310cff30fbb3cd7e9f"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def post_install
    dirs = %w[encodings 75dpi 100dpi misc]
    dirs.each do |d|
      mkdir_p share/"fonts/X11/#{d}"
    end
  end

  test do
    system "pkg-config", "--exists", "fontutil"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
