class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.227.tar.gz"
  sha256 "5b345a9f0dafc96e4d0cd2d95547702c4451691dc731f6b486ba36fd9bab7bfe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a7c88fea448764a233d72ddbbc7c14f5088a998322c66cf6573eebba42c73d4e"
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
