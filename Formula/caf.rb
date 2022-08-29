class Caf < Formula
  # Renamed from libccpa
  desc "Implementation of the Actor Model for C++"
  homepage "https://www.actor-framework.org/"
  url "https://github.com/actor-framework/actor-framework/archive/0.18.5.tar.gz"
  sha256 "4c96f896f000218bb65890b4d7175451834add73750d5f33b0c7fe82b7d5a679"
  license "BSD-3-Clause"
  head "https://github.com/actor-framework/actor-framework.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/caf"
    rebuild 3
    sha256 cellar: :any, mojave: "a8297a34fca7b871ff8c984ae38ba0a1346438580e241a8a1651a5e1632c67a8"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc" # For C++17
  end

  fails_with gcc: "5"

  def install
    tools = pkgshare/"tools"
    rpaths = [rpath, rpath(source: tools)]
    args = ["-DCAF_ENABLE_TESTING=OFF", "-DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}"]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <caf/all.hpp>
      using namespace caf;
      void caf_main(actor_system& system) {
        scoped_actor self{system};
        self->spawn([] {
          std::cout << "test" << std::endl;
        });
      }
      CAF_MAIN()
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lcaf_core", "-o", "test"
    system "./test"
  end
end
