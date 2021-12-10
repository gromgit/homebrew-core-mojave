class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.201.tar.gz"
  sha256 "6b7f9c809acff4f0877e2e7722e02a08f2e17e06c6e2e8c84081631d15490009"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c5af9ba5baaae90f9c6178814325b9d0afe4b706b65d8bb6701e6323f9cb716c"
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
