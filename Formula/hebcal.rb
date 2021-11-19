class Hebcal < Formula
  desc "Perpetual Jewish calendar for the command-line"
  homepage "https://github.com/hebcal/hebcal"
  url "https://github.com/hebcal/hebcal/archive/v4.27.tar.gz"
  sha256 "a69913029933fccc187ad1243bf57a7e799ce06b8f3d813174af3c8d78054b14"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hebcal"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a0533e307328fc6d6ec0281d1b92e216baf94bcd286a707eccddb5f39d6263db"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  uses_from_macos "gperf" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "ACLOCAL=aclocal", "AUTOMAKE=automake"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/hebcal 01 01 2020").chomp
    assert_equal output, "1/1/2020 4th of Tevet, 5780"
  end
end
