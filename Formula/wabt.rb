class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.29",
      revision: "c32fa597218dbe2c25b43a9837a8475b493ddb71"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wabt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5150fa33cb2abb62dcc077f421753c06efc6abd9afccef92af3b07c60ff2bb5b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5" # C++17

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_TESTS=OFF", "-DWITH_WASI=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"sample.wast").write("(module (memory 1) (func))")
    system "#{bin}/wat2wasm", testpath/"sample.wast"
  end
end
