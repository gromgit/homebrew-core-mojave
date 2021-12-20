class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20211203.104f822.tar.gz"
  version "20211203"
  sha256 "631ee26dce8d4906e52963bbd7b579c91e9902d0f28903d90415d20ea5b730ba"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ipbt"
    sha256 cellar: :any_skip_relocation, mojave: "5d277873f87caeef242225f9dccfe84cbe106853b0f6b26f38155d2a3deac40b"
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
