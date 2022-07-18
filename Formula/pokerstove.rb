class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/v1.0.tar.gz"
  sha256 "68503e7fc5a5b2bac451c0591309eacecba738d787874d5421c81f59fde2bc74"
  license "BSD-3-Clause"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pokerstove"
    sha256 cellar: :any, mojave: "d9aef8e68416c3d697698c05bb43535650a1762225a9eeef8c821f8be37ac3a4"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Build against our googletest instead of the included one
  # Works around https://github.com/andrewprock/pokerstove/issues/74
  patch :DATA

  def install
    rm_rf "src/ext/googletest"

    # Temporary Homebrew-specific work around for linker flag ordering problem in Ubuntu 16.04.
    # Remove after migration to 18.04.
    unless OS.mac?
      inreplace "src/lib/pokerstove/util/CMakeLists.txt",
                "gtest_main", "gtest_main pthread"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      bin.install Dir["bin/*"]
    end
  end

  test do
    system bin/"peval_tests"
  end
end

__END__
--- pokerstove-1.0/CMakeLists.txt.ORIG	2021-02-14 19:26:14.000000000 +0000
+++ pokerstove-1.0/CMakeLists.txt	2021-02-14 19:26:29.000000000 +0000
@@ -14,8 +14,8 @@
 
 # Set up gtest. This must be set up before any subdirectories are
 # added which will use gtest.
-add_subdirectory(src/ext/googletest)
-find_library(gtest REQUIRED)
+#add_subdirectory(src/ext/googletest)
+find_package(GTest REQUIRED)
 include_directories(${GTEST_INCLUDE_DIRS})
 link_directories(${GTEST_LIBS_DIR})
 add_definitions("-fPIC")
