class Netcdf < Formula
  desc "Libraries and data formats for array-oriented scientific data"
  homepage "https://www.unidata.ucar.edu/software/netcdf/"
  url "https://github.com/Unidata/netcdf-c/archive/refs/tags/v4.9.0.tar.gz"
  sha256 "9f4cb864f3ab54adb75409984c6202323d2fc66c003e5308f3cdf224ed41c0a6"
  license "BSD-3-Clause"
  head "https://github.com/Unidata/netcdf-c.git", branch: "main"

  livecheck do
    url :stable
    regex(/^(?:netcdf[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/netcdf"
    sha256 cellar: :any_skip_relocation, mojave: "17b84e90702e761538f568433a3d3acc4f7782022d846e9c67fc620949fb54b3"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  uses_from_macos "curl"

  # Patch for JSON collision. Remove in 4.9.1
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/1383fd8c15feb09c942665601d58fba3d6d5348f/netcdf/netcdf-json.diff"
    sha256 "6a5183dc734509986713a00451d7f98c5ab2e00ab0df749027067b0880fa9e92"
  end

  def install
    # Remove when this is resolved: https://github.com/Unidata/netcdf-c/issues/2390
    inreplace "CMakeLists.txt", "SET(netCDF_LIB_VERSION 19})", "SET(netCDF_LIB_VERSION 19)"

    args = std_cmake_args + %w[-DBUILD_TESTING=OFF -DENABLE_TESTS=OFF -DENABLE_NETCDF_4=ON -DENABLE_DOXYGEN=OFF]
    # Fixes "relocation R_X86_64_PC32 against symbol `stderr@@GLIBC_2.2.5' can not be used" on Linux
    args << "-DCMAKE_POSITION_INDEPENDENT_CODE=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build_shared", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
    system "cmake", "-S", ".", "-B", "build_static", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build_static"
    lib.install "build_static/liblib/libnetcdf.a"

    # Remove shim paths
    inreplace [bin/"nc-config", lib/"pkgconfig/netcdf.pc", lib/"cmake/netCDF/netCDFConfig.cmake",
               lib/"libnetcdf.settings"], Superenv.shims_path/ENV.cc, ENV.cc
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "netcdf_meta.h"
      int main()
      {
        printf(NC_VERSION);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lnetcdf",
                   "-o", "test"
    if head?
      assert_match(/^\d+(?:\.\d+)+/, `./test`)
    else
      assert_equal version.to_s, `./test`
    end
  end
end
