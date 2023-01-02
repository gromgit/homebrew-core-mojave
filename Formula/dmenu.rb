class Dmenu < Formula
  desc "Dynamic menu for X11"
  homepage "https://tools.suckless.org/dmenu/"
  url "https://dl.suckless.org/tools/dmenu-5.2.tar.gz"
  sha256 "d4d4ca77b59140f272272db537e05bb91a5914f56802652dc57e61a773d43792"
  license "MIT"
  head "https://git.suckless.org/dmenu/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?dmenu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dmenu"
    sha256 cellar: :any, mojave: "8e1278286bc1c38f5b9882598c99291d216d1c8beb6c8b3e2f25ca417650f83d"
  end

  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"

  def install
    system "make", "FREETYPEINC=#{HOMEBREW_PREFIX}/include/freetype2", "PREFIX=#{prefix}", "install"
  end

  test do
    # Disable test on Linux because it fails with this error:
    # cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "warning: no locale support", shell_output("#{bin}/dmenu 2>&1", 1)
  end
end
