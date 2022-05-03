class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin) with Python bindings (Pivy)"
  homepage "https://coin3d.github.io/"
  license all_of: ["BSD-3-Clause", "ISC"]
  revision 2

  stable do
    url "https://github.com/coin3d/coin/archive/Coin-4.0.0.tar.gz"
    sha256 "b00d2a8e9d962397cf9bf0d9baa81bcecfbd16eef675a98c792f5cf49eb6e805"

    resource "pivy" do
      url "https://github.com/coin3d/pivy/archive/0.6.6.tar.gz"
      sha256 "27204574d894cc12aba5df5251770f731f326a3e7de4499e06b5f5809cc5659e"
    end
  end

  livecheck do
    url :stable
    regex(/^Coin[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/coin3d"
    rebuild 1
    sha256 cellar: :any, mojave: "7edd36418ca915fd4f654492352d405e84eaa0472908ce0de5b82417e79324ee"
  end

  head do
    url "https://github.com/coin3d/coin.git"

    resource "pivy" do
      url "https://github.com/coin3d/pivy.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "pyside@2"
  depends_on "python@3.9"

  def install
    # Create an empty directory for cpack to make the build system
    # happy. This is a workaround for a build issue on upstream that
    # was fixed by commit be8e3d57aeb5b4df6abb52c5fa88666d48e7d7a0 but
    # hasn't made it to a release yet.
    mkdir "cpack.d" do
      touch "CMakeLists.txt"
    end

    mkdir "cmakebuild" do
      args = std_cmake_args + %w[
        -GNinja
        -DCOIN_BUILD_MAC_FRAMEWORK=OFF
        -DCOIN_BUILD_DOCUMENTATION=ON
        -DCOIN_BUILD_TESTS=OFF
      ]

      system "cmake", "..", *args
      system "ninja", "install"
    end

    resource("pivy").stage do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["LDFLAGS"] = "-rpath #{opt_lib}"
      system Formula["python@3.9"].opt_bin/"python3",
             *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", "-Wl,-framework,OpenGL", \
           "-o", "test"
    system "./test"

    xy = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    ENV.append_path "PYTHONPATH", "#{Formula["pyside@2"].opt_lib}/python#{xy}/site-packages"
    system Formula["python@3.9"].opt_bin/"python3", "-c", <<~EOS
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    EOS
  end
end
