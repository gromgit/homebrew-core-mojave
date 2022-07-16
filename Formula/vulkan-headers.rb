class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.221.tar.gz"
  sha256 "75057d8231bb7a3f6ac091f1b08f50604f07a7e9b4424fd12c035f01787ebf0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5f16f91d7e544b67081240ee99595b398089540bbe700cee0be94f428ecc1bb4"
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
