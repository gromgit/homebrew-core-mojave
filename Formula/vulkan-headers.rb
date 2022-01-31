class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.204.tar.gz"
  sha256 "2cde2c90975a8f36d00cf8eb6308cb00323aafbc0b7374f4b346f1140f760b3d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eab5f886659cfa995c2e2a09b2c22a48e7d09e2d876efa8733bf3eb78b15f92f"
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
