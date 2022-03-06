class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-5.1.tar.gz"
  sha256 "1f4d709ebba37eb7326eba0e665e0f13be4fa24ee35c95b0d79c30f14a348fd5"
  license "MIT"
  head "https://git.suckless.org/dmenu/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?dmenu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dmenu"
    rebuild 1
    sha256 cellar: :any, mojave: "c74625665bfb540ba226b86293f04fc54f60be2768eb45ecc0e6cc6363d0309b"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    system "make", "FREETYPEINC=#{HOMEBREW_PREFIX}/include/freetype2", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match "warning: no locale support", shell_output("#{bin}/dmenu 2>&1", 1)
  end
end
