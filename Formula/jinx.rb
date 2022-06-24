class Jinx < Formula
  desc "Embeddable scripting language for real-time applications"
  homepage "https://github.com/JamesBoer/Jinx"
  url "https://github.com/JamesBoer/Jinx/archive/v1.3.9.tar.gz"
  sha256 "ea724319c902405eb16db3acdf6a31813c2bfd20e8312c1ade3d751ad8adc2ea"
  license "MIT"
  head "https://github.com/JamesBoer/Jinx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jinx"
    sha256 cellar: :any_skip_relocation, mojave: "19d19aa4b29a0f37ee1f94858e8b7052e936d1117389cb292af67da82b1a2bba"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    # disable building tests
    inreplace "CMakeLists.txt", "if(NOT jinx_is_subproject)", "if(FALSE)"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      lib.install "libJinx.a"
    end

    include.install Dir["Source/*.h"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "Jinx.h"

      int main() {
        // Create the Jinx runtime object
        auto runtime = Jinx::CreateRuntime();

        // Text containing our Jinx script
        const char * scriptText =
        u8R"(

        -- Use the core library
        import core

        -- Write to the debug output
        write line "Hello, world!"

        )";

        // Create and execute a script object
        auto script = runtime->ExecuteScript(scriptText);
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lJinx", "-o", "test"
    assert_match "Hello, world!", shell_output("./test")
  end
end
