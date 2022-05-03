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
    rebuild 2
    sha256 cellar: :any, mojave: "f0e675a0ca4fb5205f3b513ca089893522b60da8ae6d45c86adf8a34b6ec2b88"
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
