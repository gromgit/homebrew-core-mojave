class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.25",
      revision: "b3f1efb261b059d40a4d103c803ccbe3c32df7ae"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wabt"
    sha256 cellar: :any_skip_relocation, mojave: "336c03e501d74919b3d9ffddb465f19129dfa0c13d107a3eec9e5224256d2939"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
