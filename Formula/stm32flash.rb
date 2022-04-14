class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.7.tar.gz"
  sha256 "c4c9cd8bec79da63b111d15713ef5cc2cd947deca411d35d6e3065e227dc414a"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/stm32flash[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stm32flash"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0118a701843f0d74899fdba66d41faff5fb9113bf842a98ef107400d429d7d24"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/stm32flash -k /dev/tty.XYZ 2>&1", 1)
    assert_match "Failed to open port: /dev/tty.XYZ", output
  end
end
