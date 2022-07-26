class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.222.tar.gz"
  sha256 "e4521bd92f704d0dd2586d6d164857667e0eee04db7e19643a1a3627d9153ea7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bdd8a282dd31c26c693409868faf353b82ecb96b81333e3101c40ea325607c5a"
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
