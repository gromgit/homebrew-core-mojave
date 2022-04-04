class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/IoLanguage/io/archive/2017.09.06.tar.gz"
  sha256 "9ac5cd94bbca65c989cd254be58a3a716f4e4f16480f0dc81070457aa353c217"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/IoLanguage/io.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/io"
    rebuild 1
    sha256 mojave: "c9faeefd255141b768490aecac8ce676751fa20939a303deaa0322aae9e52015"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "libxml2"

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    unless build.head?
      # Turn off all add-ons in main cmake file
      inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                  "#add_subdirectory(addons)"
    end

    mkdir "buildroot" do
      system "cmake", "..", "-DCMAKE_DISABLE_FIND_PACKAGE_ODE=ON",
                            "-DCMAKE_DISABLE_FIND_PACKAGE_Theora=ON",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.io").write <<~EOS
      "it works!" println
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end
