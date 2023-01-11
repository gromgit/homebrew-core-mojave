class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20220403.d4e7fcd.tar.gz"
  version "20220403"
  sha256 "8c7f325166b86055232cca9d745c6a18dcdcb6d30a0685e07ac0eab677912b05"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ipbt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a8b2e690bdd4b472c50412f6b02e19e7cc5bde35338b9b05bc1040b2261c1f5a"
  end

  depends_on "cmake" => :build

  uses_from_macos "ncurses"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
