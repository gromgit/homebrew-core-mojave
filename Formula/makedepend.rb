class Makedepend < Formula
  desc "Creates dependencies in makefiles"
  homepage "https://x.org/"
  url "https://xorg.freedesktop.org/releases/individual/util/makedepend-1.0.8.tar.xz"
  sha256 "bfb26f8025189b2a01286ce6daacc2af8fe647440b40bb741dd5c397572cba5b"
  license "MIT"

  livecheck do
    url "https://xorg.freedesktop.org/releases/individual/util/"
    regex(/href=.*?makedepend[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/makedepend"
    sha256 cellar: :any_skip_relocation, mojave: "839e231b5f0416e42384f5efd4b1fa3f5479e579bdc07daf1fc17016a69f402d"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros"
  depends_on "xorgproto"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          *std_configure_args
    system "make", "install"
  end

  test do
    touch "Makefile"
    system "#{bin}/makedepend"
  end
end
