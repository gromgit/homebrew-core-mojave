class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.225.tar.gz"
  sha256 "71bfa18ef3df0c39b1dc194727166e4ec1c51df7254ac86e0b9c27fd10cf85ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "720c3f4a102e9cd634136df870734468a9057430a53b48d608fa38b6c8352103"
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
