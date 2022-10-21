class Nickle < Formula
  desc "Desk calculator language"
  homepage "https://www.nickle.org/"
  url "https://deb.debian.org/debian/pool/main/n/nickle/nickle_2.91.tar.xz"
  sha256 "a27a063d4cb93701d2d05a5fb2895b51b28fa7a2b32463a829496fb5f63833b6"
  license "MIT"
  head "https://keithp.com/cgit/nickle.git", branch: "master"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/n/nickle/"
    regex(/href=.*?nickle[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nickle"
    sha256 mojave: "b771d2ba375339af04cb321772f857449a75ea65e5e338409ede5b71fa6b4863"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "flex" => :build # conflicting types for 'yyget_leng'
  depends_on "readline"

  uses_from_macos "bison" => :build

  def install
    system "./autogen.sh", *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal "4", shell_output("#{bin}/nickle -e '2+2'").chomp
  end
end
