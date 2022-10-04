class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://github.com/homenc/HElib/archive/v2.2.1.tar.gz"
  sha256 "cbe030c752c915f1ece09681cadfbe4f140f6752414ab000b4cf076b6c3019e4"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/helib"
    rebuild 1
    sha256 cellar: :any, mojave: "c4658396c7b8b65a666e0b45b57d6def5ada0d40321a449cabab20f6a6fbd2d7"
  end

  depends_on "cmake" => :build
  depends_on "bats-core" => :test
  depends_on "gmp"
  depends_on "ntl"

  fails_with gcc: "5" # for C++17

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/BGV_country_db_lookup/BGV_country_db_lookup.cpp", testpath/"test.cpp"
    mkdir "build"
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-pthread", "-lhelib", "-lntl", "-o", "build/BGV_country_db_lookup"

    cp_r pkgshare/"examples/tests", testpath
    system "bats", "."
  end
end
