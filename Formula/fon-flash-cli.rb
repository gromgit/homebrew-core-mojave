class FonFlashCli < Formula
  desc "Flash La Fonera and Atheros chipset compatible devices"
  homepage "https://www.gargoyle-router.com/wiki/doku.php?id=fon_flash"
  url "https://github.com/ericpaulbishop/gargoyle/archive/1.13.0.tar.gz"
  sha256 "8086c5c0725f520b659eecca5784a9f0f25eb8eac0deafc967f0264977b3fbe1"
  license "GPL-2.0-or-later"
  head "https://github.com/ericpaulbishop/gargoyle.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fon-flash-cli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d3ca04c4988dc059d0fab5dd0e3377e6a9a39bb5cbec4bb5e68a487cc5a344ad"
  end

  uses_from_macos "libpcap"

  def install
    cd "fon-flash" do
      system "make", "fon-flash"
      bin.install "fon-flash"
    end
  end

  test do
    system "#{bin}/fon-flash"
  end
end
