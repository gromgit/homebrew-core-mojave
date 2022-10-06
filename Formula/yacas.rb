class Yacas < Formula
  desc "General purpose computer algebra system"
  homepage "https://www.yacas.org/"
  url "https://github.com/grzegorzmazur/yacas/archive/v1.9.1.tar.gz"
  sha256 "36333e9627a0ed27def7a3d14628ecaab25df350036e274b37f7af1d1ff7ef5b"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yacas"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2f3951bb3ecc3921f2f934316c5fe232834fcebbc729e85014b1de6fb858b281"
  end

  depends_on "cmake" => :build

  fails_with :gcc do
    version "6"
    cause "needs std::string_view"
  end

  def install
    cmake_args = std_cmake_args + [
      "-DENABLE_CYACAS_GUI=OFF",
      "-DENABLE_CYACAS_KERNEL=OFF",
      "-DCMAKE_C_COMPILER=#{ENV.cc}",
      "-DCMAKE_CXX_COMPILER=#{ENV.cxx}",
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "scripts"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yacas -v")
  end
end
