class Agedu < Formula
  desc "Unix utility for tracking down wasted disk space"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/agedu/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/agedu/agedu-20211129.8cd63c5.tar.gz"
  version "20211129"
  sha256 "ceaee592ef21b8cbb254aa7e9c5d22cefab24535e137618a4d0af591eba8339f"
  license "MIT"
  head "https://git.tartarus.org/simon/agedu.git", branch: "main"

  livecheck do
    url :homepage
    regex(/href=.*?agedu[._-]v?(\d+(?:\.\d+)*)(?:[._-][\da-z]+)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/agedu"
    sha256 cellar: :any_skip_relocation, mojave: "45737e5f5b420fb2ea2182f133e3f29c911c5f852aa28cd1e5352821fb3c444a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"agedu", "-s", "."
    assert_predicate testpath/"agedu.dat", :exist?
  end
end
