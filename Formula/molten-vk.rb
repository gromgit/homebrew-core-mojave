class MoltenVk < Formula
  desc "Implementation of the Vulkan graphics and compute API on top of Metal"
  homepage "https://github.com/KhronosGroup/MoltenVK"
  license "Apache-2.0"

  stable do
    url "https://github.com/KhronosGroup/MoltenVK/archive/v1.1.11.tar.gz"
    sha256 "938ea0ba13c6538b0ee505ab391a3020f206ab9d29c869f20dd19318a4ee8997"

    # MoltenVK depends on very specific revisions of its dependencies.
    # For each resource the path to the file describing the expected
    # revision is listed.
    resource "SPIRV-Cross" do
      # ExternalRevisions/SPIRV-Cross_repo_revision
      url "https://github.com/KhronosGroup/SPIRV-Cross.git",
          revision: "61c603f3baa5270e04bcfb6acf83c654e3c57679"
    end

    resource "Vulkan-Headers" do
      # ExternalRevisions/Vulkan-Headers_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Headers.git",
          revision: "c896e2f920273bfee852da9cca2a356bc1c2031e"
    end

    resource "Vulkan-Tools" do
      # ExternalRevisions/Vulkan-Tools_repo_revision
      url "https://github.com/KhronosGroup/Vulkan-Tools.git",
          revision: "497f232680b046db34ba9e9da065e6303a125851"
    end

    resource "cereal" do
      # ExternalRevisions/cereal_repo_revision
      url "https://github.com/USCiLab/cereal.git",
          revision: "51cbda5f30e56c801c07fe3d3aba5d7fb9e6cca4"
    end

    resource "glslang" do
      # ExternalRevisions/glslang_repo_revision
      url "https://github.com/KhronosGroup/glslang.git",
          revision: "73c9630da979017b2f7e19c6549e2bdb93d9b238"
    end

    resource "SPIRV-Tools" do
      # known_good.json in the glslang repository
      url "https://github.com/KhronosGroup/SPIRV-Tools.git",
          revision: "5e61ea2098220059e89523f1f47b0bcd8c33b89a"
    end

    resource "SPIRV-Headers" do
      # known_good.json in the glslang repository
      url "https://github.com/KhronosGroup/SPIRV-Headers.git",
          revision: "b2a156e1c0434bc8c99aaebba1c7be98be7ac580"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a3d54d5780f6cceae7f5927a5f4cbdfa4063f4c9ed6987c5c20b2c95aa0a3cf3"
    sha256 cellar: :any, arm64_big_sur:  "1144fba33228925521a37f5a115482d4786f3d62b8cc82f73bf5b4441ea56e54"
    sha256 cellar: :any, monterey:       "cca29807dbf7e5094c0ce36114185c7fb304874818f2d4150d0b2aac5ac2c07c"
    sha256 cellar: :any, big_sur:        "1bf9a96de03507e3ce9ff7c68c0b511cbeae568d3ed1093af514754dba0663f5"
    sha256 cellar: :any, catalina:       "1596e32fd701de80957abb0ea691414dc785e95f87d2602e7e52e4678b70f217"
  end

  head do
    url "https://github.com/KhronosGroup/MoltenVK.git", branch: "master"

    resource "cereal" do
      url "https://github.com/USCiLab/cereal.git", branch: "master"
    end

    resource "Vulkan-Headers" do
      url "https://github.com/KhronosGroup/Vulkan-Headers.git", branch: "main"
    end

    resource "SPIRV-Cross" do
      url "https://github.com/KhronosGroup/SPIRV-Cross.git", branch: "master"
    end

    resource "glslang" do
      url "https://github.com/KhronosGroup/glslang.git", branch: "master"
    end

    resource "SPIRV-Tools" do
      url "https://github.com/KhronosGroup/SPIRV-Tools.git", branch: "master"
    end

    resource "SPIRV-Headers" do
      url "https://github.com/KhronosGroup/SPIRV-Headers.git", branch: "master"
    end

    resource "Vulkan-Tools" do
      url "https://github.com/KhronosGroup/Vulkan-Tools.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build
  depends_on xcode: ["11.7", :build]
  # Requires IOSurface/IOSurfaceRef.h.
  depends_on macos: :sierra
  depends_on :macos # Linux does not have a Metal implementation. Not implied by the line above.

  def install
    resources.each do |res|
      res.stage(buildpath/"External"/res.name)
    end
    mv "External/SPIRV-Tools", "External/glslang/External/spirv-tools"
    mv "External/SPIRV-Headers", "External/glslang/External/spirv-tools/external/spirv-headers"

    # Build glslang
    cd "External/glslang" do
      system "./build_info.py", ".",
              "-i", "build_info.h.tmpl",
              "-o", "build/include/glslang/build_info.h"
    end

    # Build spirv-tools
    mkdir "External/glslang/External/spirv-tools/build" do
      # Required due to files being generated during build.
      system "cmake", "..", *std_cmake_args
      system "make"
    end

    # Build ExternalDependencies
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "ExternalDependencies.xcodeproj",
               "-scheme", "ExternalDependencies-macOS",
               "-derivedDataPath", "External/build",
               "SYMROOT=External/build", "OBJROOT=External/build",
               "build"

    # Build MoltenVK Package
    xcodebuild "ARCHS=#{Hardware::CPU.arch}", "ONLY_ACTIVE_ARCH=YES",
               "-project", "MoltenVKPackaging.xcodeproj",
               "-scheme", "MoltenVK Package (macOS only)",
               "-derivedDataPath", "#{buildpath}/build",
               "SYMROOT=#{buildpath}/build", "OBJROOT=build",
               "build"

    (libexec/"lib").install Dir["External/build/Intermediates/XCFrameworkStaging/Release/" \
                                "Platform/lib{SPIRVCross,SPIRVTools,glslang}.a"]
    glslang_dir = Pathname.new("External/glslang")
    Pathname.glob("External/glslang/{glslang,SPIRV}/**/*.{h,hpp}") do |header|
      header.chmod 0644
      (libexec/"include"/header.parent.relative_path_from(glslang_dir)).install header
    end
    (libexec/"include").install "External/SPIRV-Cross/include/spirv_cross"
    (libexec/"include").install "External/glslang/External/spirv-tools/include/spirv-tools"
    (libexec/"include").install "External/Vulkan-Headers/include/vulkan" => "vulkan"
    (libexec/"include").install "External/Vulkan-Headers/include/vk_video" => "vk_video"

    frameworks.install "Package/Release/MoltenVK/MoltenVK.xcframework"
    lib.install "Package/Release/MoltenVK/dylib/macOS/libMoltenVK.dylib"
    lib.install "build/Release/libMoltenVK.a"
    include.install "MoltenVK/MoltenVK/API" => "MoltenVK"

    bin.install "Package/Release/MoltenVKShaderConverter/Tools/MoltenVKShaderConverter"
    frameworks.install "Package/Release/MoltenVKShaderConverter/" \
                       "MoltenVKShaderConverter.xcframework"
    include.install Dir["Package/Release/MoltenVKShaderConverter/include/" \
                        "MoltenVKShaderConverter"]

    inreplace "MoltenVK/icd/MoltenVK_icd.json",
              "./libMoltenVK.dylib",
              (lib/"libMoltenVK.dylib").relative_path_from(share/"vulkan/icd.d")
    (share/"vulkan").install "MoltenVK/icd" => "icd.d"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vulkan/vulkan.h>
      int main(void) {
        const char *extensionNames[] = { "VK_KHR_surface" };
        VkInstanceCreateInfo instanceCreateInfo = {
          VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, NULL,
          0, NULL,
          0, NULL,
          1, extensionNames,
        };
        VkInstance inst;
        vkCreateInstance(&instanceCreateInfo, NULL, &inst);
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.cpp", "-I#{include}", "-I#{libexec/"include"}", "-L#{lib}", "-lMoltenVK"
    system "./test"
  end
end
