class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v4.0.1.tar.gz"
  sha256 "01891901707c6430caaea7e645ff5ac6980cae166094a6f924ded197e5774a19"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/h3"
    sha256 cellar: :any, mojave: "34e0d2c49ecd202c9a2dd5a8d7f93c72655083adf6a99db5d5e51c5206671d6d"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    result = pipe_output("#{bin}/latLngToCell -r 10 --lat 40.689167 --lng -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
