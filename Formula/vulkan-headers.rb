class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.202.tar.gz"
  sha256 "df8748ba3073be032f78c97994798c3c2b52b1812e506cc58855faf10f031226"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "532141c85ce846cd4adbc6d1d5745211da8467f1e1de334a747a49d0bfb420ee"
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
