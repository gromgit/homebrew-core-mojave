class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.210.tar.gz"
  sha256 "e3a1bb9e089c62a8ad62b19f9617f382e974536d00dac39d190a2a1b95d1ea89"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4df81649b7179f85347c3bdc371ca1618ac379a8dc50a201c22bae4366c02381"
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
