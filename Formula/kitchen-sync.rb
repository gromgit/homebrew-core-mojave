class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/v2.14.tar.gz"
  sha256 "bcdcb1ea70ed29b6a298782513edd29b5f804b19c6a4c26defdaeaabc249165a"
  license "MIT"
  head "https://github.com/willbryant/kitchen_sync.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kitchen-sync"
    sha256 cellar: :any, mojave: "6adf34e101b9622c2c811351785e6a5ac623df2134fb4d05280721f6171f59fd"
  end

  depends_on "cmake" => :build
  depends_on "libpq"
  depends_on "mysql-client"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".",
                    "-DMySQL_INCLUDE_DIR=#{Formula["mysql-client"].opt_include}/mysql",
                    "-DMySQL_LIBRARY_DIR=#{Formula["mysql-client"].opt_lib}",
                    "-DPostgreSQL_INCLUDE_DIR=#{Formula["libpq"].opt_include}",
                    "-DPostgreSQL_LIBRARY_DIR=#{Formula["libpq"].opt_lib}",
                    *std_cmake_args

    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from mysql://b/ --to mysql://d/ 2>&1", 1)

    assert_match "Unknown MySQL server host", output
    assert_match "Kitchen Syncing failed.", output
  end
end
