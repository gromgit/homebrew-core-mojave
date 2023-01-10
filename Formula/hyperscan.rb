class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.4.0.tar.gz"
  sha256 "e51aba39af47e3901062852e5004d127fa7763b5dbbc16bcca4265243ffa106f"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hyperscan"
    rebuild 1
    sha256 cellar: :any, mojave: "e17ada21043fcbe79d52dacbfb2b2cf017bf198f9b4755918a331388bdd6887b"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "ragel" => :build
  # Only supports x86 instructions and will fail to build on ARM.
  # See https://github.com/intel/hyperscan/issues/197
  depends_on arch: :x86_64
  depends_on "pcre"

  # fixes glibc 2.34 issue https://github.com/intel/hyperscan/issues/359
  # remove in version > 5.4.0
  patch do
    url "https://github.com/intel/hyperscan/commit/564ed6f65a1058e4e0adab69bdd17ba9138c8a0c.patch?full_index=1"
    sha256 "21a22ac92c8f61c3b06f72919d356d594fc89d090eb1f238ce11e89d55e22bfb"
  end

  def install
    cmake_args = std_cmake_args + ["-DBUILD_STATIC_AND_SHARED=ON"]

    # Linux CI cannot guarantee AVX2 support needed to build fat runtime.
    cmake_args << "-DFAT_RUNTIME=OFF" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
