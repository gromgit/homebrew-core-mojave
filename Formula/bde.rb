class Bde < Formula
  desc "Basic Development Environment: foundational C++ libraries used at Bloomberg"
  homepage "https://github.com/bloomberg/bde"
  url "https://github.com/bloomberg/bde/archive/3.61.0.0.tar.gz"
  sha256 "46dcdcf06f3cf582170848721dd6d8ca9c993f9cfa34445103d3cee34a5d6dda"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bde"
    rebuild 2
    sha256 cellar: :any, mojave: "d1e756066fb1259cef889ffc82da3ca18d6f8834f358f8ddeb0d6dcc8f3e6394"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
  depends_on "pcre2"

  resource "bde-tools" do
    url "https://github.com/bloomberg/bde-tools/archive/3.61.0.0.tar.gz"
    sha256 "7d66eb149c7e59021467c386ba5c6149a8923e836c6a61b815651b3cac019a7d"
  end

  # Backport support for Apple Silicon. Remove in the next release
  patch do
    on_arm do
      url "https://github.com/bloomberg/bde/commit/39a52e09c83eec761874be2260b692b715117fae.patch?full_index=1"
      sha256 "d3721d8a297687ddd2003386845aaa6ec3f8664ab81551b1ef581fe65ad1cb96"
    end
  end

  def install
    buildpath.install resource("bde-tools")

    # Use brewed pcre2 instead of bundled sources
    inreplace "project.cmake", "${listDir}/thirdparty/pcre2\n", ""
    inreplace "groups/bdl/group/bdl.dep", "pcre2", "libpcre2-posix"
    inreplace "groups/bdl/bdlpcre/bdlpcre_regex.h", "#include <pcre2/pcre2.h>", "#include <pcre2.h>"

    toolchain_file = "cmake/toolchains/#{OS.kernel_name.downcase}/default.cmake"
    args = std_cmake_args + %W[
      -DBUILD_BITNESS=64
      -DUFID=opt_exc_mt_64_shr
      -DCMAKE_MODULE_PATH=cmake
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_TOOLCHAIN_FILE=#{toolchain_file}
      -DPYTHON_EXECUTABLE=#{which("python3.10")}
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # CMake install step does not conform to FHS
    lib.install Dir[bin/"so/64/*"]
    lib.install lib/"opt_exc_mt_shr/cmake"
  end

  test do
    # bde tests are incredibly performance intensive
    # test below does a simple sanity check for linking against bsl.
    (testpath/"test.cpp").write <<~EOS
      #include <bsl_string.h>
      #include <bslma_default.h>
      int main() {
        using namespace BloombergLP;
        bsl::string string(bslma::Default::globalAllocator());
        return 0;
      }
    EOS
    system ENV.cxx, "-I#{include}", "test.cpp", "-L#{lib}", "-lbsl", "-o", "test"
    system "./test"
  end
end
