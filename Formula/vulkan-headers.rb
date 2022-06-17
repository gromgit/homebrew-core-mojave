class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.218.tar.gz"
  sha256 "9fd435580db06105036dee3c98a1c6460dea5e9ec618b8ca02fa2da463d14e27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f0caa48173fd265a486d6cee7103c8f7f01286d0e638b0760c60906b5379bf7"
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
