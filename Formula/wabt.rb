class Wabt < Formula
  desc "Web Assembly Binary Toolkit"
  homepage "https://github.com/WebAssembly/wabt"
  url "https://github.com/WebAssembly/wabt.git",
      tag:      "1.0.24",
      revision: "21279a861fa3dbac9af9d2bab16c741df17a86af"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wabt"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "21470e86bb4ccb336cf558a8b4789c385c6bea78faf3a74a2c970afccede5646"
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
