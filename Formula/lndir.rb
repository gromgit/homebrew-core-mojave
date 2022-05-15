class Lndir < Formula
  desc "Create a shadow directory of symbolic links to another directory tree"
  homepage "https://gitlab.freedesktop.org/xorg/util/lndir"
  url "https://www.x.org/releases/individual/util/lndir-1.0.3.tar.bz2"
  sha256 "49f4fab0de8d418db4ce80dad34e9b879a4199f3e554253a8e1ab68f7c7cb65d"
  license "MIT-open-group"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lndir"
    sha256 cellar: :any_skip_relocation, mojave: "6df740c13c91b686a09a371d864ff479692d6a0623eb9ec01d4a3051b9ed89ff"
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"  => :build

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    mkdir "test"
    system bin/"lndir", bin, "test"
    assert_predicate testpath/"test/lndir", :exist?
  end
end
