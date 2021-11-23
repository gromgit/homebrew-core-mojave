class Irrlicht < Formula
  desc "Realtime 3D engine"
  homepage "https://irrlicht.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/1.8/1.8.5/irrlicht-1.8.5.zip"
  sha256 "effb7beed3985099ce2315a959c639b4973aac8210f61e354475a84105944f3d"
  # Irrlicht is available under alternative license terms. See
  # https://metadata.ftp-master.debian.org/changelogs//main/i/irrlicht/irrlicht_1.8.4+dfsg1-1.1_copyright
  license "Zlib"
  head "https://svn.code.sf.net/p/irrlicht/code/trunk"

  livecheck do
    url :stable
    regex(%r{url=.*?/irrlicht[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)}i)
  end

  depends_on xcode: :build

  depends_on "jpeg"
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
    depends_on "libxxf86vm"
    depends_on "mesa"
  end

  # Use libraries from Homebrew or macOS
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/69ad57d16cdd4ecdf2dfa50e9ce751b082d78cf9/irrlicht/use-system-libs.patch"
    sha256 "70d2534506e0e34279c3e9d8eff4b72052cb2e78a63d13ce0bc60999cbdb411b"
  end

  # Update Xcode project to use libraries from Homebrew and macOS
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/69ad57d16cdd4ecdf2dfa50e9ce751b082d78cf9/irrlicht/xcode.patch"
    sha256 "2cfcc34236469fcdb24b6a77489272dfa0a159c98f63513781245f3ef5c941c0"
  end

  def install
    if OS.mac?
      inreplace "source/Irrlicht/MacOSX/MacOSX.xcodeproj/project.pbxproj" do |s|
        s.gsub! "@LIBPNG_PREFIX@", Formula["libpng"].opt_prefix
        s.gsub! "@JPEG_PREFIX@", Formula["jpeg"].opt_prefix
      end

      extra_args = []

      # Fix "Undefined symbols for architecture arm64: "_png_init_filter_functions_neon"
      # Reported 18 Nov 2020 https://sourceforge.net/p/irrlicht/bugs/452/
      extra_args << "GCC_PREPROCESSOR_DEFINITIONS='PNG_ARM_NEON_OPT=0'" if Hardware::CPU.arm?

      xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
                 "-configuration", "Release",
                 "-target", "IrrFramework",
                 "SYMROOT=build",
                 *extra_args

      xcodebuild "-project", "source/Irrlicht/MacOSX/MacOSX.xcodeproj",
                 "-configuration", "Release",
                 "-target", "libIrrlicht.a",
                 "SYMROOT=build",
                 *extra_args

      frameworks.install "source/Irrlicht/MacOSX/build/Release/IrrFramework.framework"
      lib.install_symlink frameworks/"IrrFramework.framework/Versions/A/IrrFramework" => "libIrrlicht.dylib"
      lib.install "source/Irrlicht/MacOSX/build/Release/libIrrlicht.a"
      include.install "include" => "irrlicht"
    else
      cd "source/Irrlicht" do
        inreplace "Makefile" do |s|
          s.gsub! "/usr/X11R6/lib$(LIBSELECT)", Formula["libx11"].opt_lib
          s.gsub! "/usr/X11R6/include", Formula["libx11"].opt_include
        end
        ENV.append "LDFLAGS", "-L#{Formula["mesa"].opt_lib}"
        ENV.append "LDFLAGS", "-L#{Formula["libxxf86vm"].opt_lib}"
        ENV.append "CXXFLAGS", "-I#{Formula["libxxf86vm"].opt_include}"
        system "make", "sharedlib", "NDEBUG=1"
        system "make", "install", "INSTALL_DIR=#{lib}"
        system "make", "clean"
        system "make", "staticlib", "NDEBUG=1"
      end
      lib.install "lib/Linux/libIrrlicht.a"
    end

    (pkgshare/"examples").install "examples/01.HelloWorld"
  end

  test do
    on_macos do
      assert_match Hardware::CPU.arch.to_s, shell_output("lipo -info #{lib}/libIrrlicht.a")
    end
    cp_r Dir["#{pkgshare}/examples/01.HelloWorld/*"], testpath
    system ENV.cxx, "main.cpp", "-I#{include}/irrlicht", "-L#{lib}", "-lIrrlicht", "-o", "hello"
  end
end
