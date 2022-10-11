class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.230.tar.gz"
  sha256 "7ffa5489eb64c11449ebc63579cbbd3bf6d8144cdd96434033f837c2b615847d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ee858f991c5548a3a69d1eadbf9ddc147d0f3cce6e6c346cc9de00de570f6114"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
