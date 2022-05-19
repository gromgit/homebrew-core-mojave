class OpenSceneGraph < Formula
  desc "3D graphics toolkit"
  homepage "https://github.com/openscenegraph/OpenSceneGraph"
  license "LGPL-2.1-or-later" => { with: "WxWindows-exception-3.1" }
  revision 2
  head "https://github.com/openscenegraph/OpenSceneGraph.git", branch: "master"

  stable do
    url "https://github.com/openscenegraph/OpenSceneGraph/archive/OpenSceneGraph-3.6.5.tar.gz"
    sha256 "aea196550f02974d6d09291c5d83b51ca6a03b3767e234a8c0e21322927d1e12"

    # patch to fix build from source when asio library is present
    patch do
      url "https://github.com/openscenegraph/OpenSceneGraph/commit/21f5a0adfb57dc4c28b696e93beface45de28194.patch?full_index=1"
      sha256 "d1e4e33b50ab006420417c7998d7e0d43d0349e6f407b5eb92a3fc6636523fbf"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/open-scene-graph"
    sha256 mojave: "019da331e0bce5f738c4aad2c85b0c7d91d3e09a874c7940afd9fd498518d37b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "sdl2"

  on_linux do
    depends_on "librsvg"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Fix "fatal error: 'os/availability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    # Requires the CLT to be the active developer directory if Xcode is installed
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    args = std_cmake_args + %w[
      -DBUILD_DOCUMENTATION=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_FFmpeg=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_GDAL=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_Jasper=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_OpenEXR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_SDL=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON
      -DCMAKE_CXX_FLAGS=-Wno-error=narrowing
    ]

    if OS.mac?
      args += %w[
        -DCMAKE_OSX_ARCHITECTURES=x86_64
        -DOSG_DEFAULT_IMAGE_PLUGIN_FOR_OSX=imageio
        -DOSG_WINDOWING_SYSTEM=Cocoa
      ]
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "doc_openscenegraph"
      system "make", "install"
      doc.install Dir["#{prefix}/doc/OpenSceneGraphReferenceDocs/*"]
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <osg/Version>
      using namespace std;
      int main()
        {
          cout << osgGetVersion() << endl;
          return 0;
        }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-losg", "-o", "test"
    assert_equal `./test`.chomp, version.to_s
  end
end
