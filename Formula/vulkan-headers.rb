class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.220.tar.gz"
  sha256 "a41707ef4cd506626990799f7679c64c2e9cc72b8641bed69a7fec16a850930f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc08dd866ea31548322f43eee3fb6f51912f2d63e75ec034396f6242fe1b82c8"
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
