class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.228.tar.gz"
  sha256 "e5a4dcdfb9361ee8d1b9401ed337b65e7c34a54224b99a9cde303a650a9cb350"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d83ba07bd8abe979db0e90c54c5d1a676e98779d6f414dfdaa11d4d431f397f"
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
