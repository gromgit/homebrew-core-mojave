class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.4.tar.gz"
  sha256 "ff0121b4ec070407e29720c801b7e1a972042300d37560a62c57abadc9635634"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/libtins.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libtins"
    sha256 cellar: :any, mojave: "a791822b0b5ed3021a8e330cc1bef25fecf673ae93757b27fe044e24dd6cb78e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libpcap"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DLIBTINS_ENABLE_CXX11=1"
      system "make", "install"
      doc.install "examples"
    end

    # Clean up the build file garbage that has been installed.
    rm_r Dir[share/"doc/libtins/**/CMakeFiles/"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
