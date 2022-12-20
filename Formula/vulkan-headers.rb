class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.238.tar.gz"
  sha256 "c2b72c5e94bcabb5c276c0d55344f66d3486c9465beb74397aeb7d5bcf537143"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "46f0941d3210dff9b96a75aa615ac89f863180306a2038569103c57bb30835b2"
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
