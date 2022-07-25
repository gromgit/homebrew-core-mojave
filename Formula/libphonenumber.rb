class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/google/libphonenumber"
  url "https://github.com/google/libphonenumber/archive/v8.12.51.tar.gz"
  sha256 "a375c51a2eefb041fb1135bcbd6ddf6ff2c9a031d098393630665f5ec7b10257"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libphonenumber"
    sha256 cellar: :any, mojave: "de4fc80502e728d47db29e5ea7f47058acf13c1dc026b350129e5b7c306ac9e2"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "re2"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # For abseil and C++17

  # Use Homebrew abseil.
  # https://github.com/google/libphonenumber/pull/2791
  patch do
    url "https://github.com/google/libphonenumber/commit/035901b78dbe5a6fddc9e758f0069c310750db72.patch?full_index=1"
    sha256 "006843f29cb42e0d8ef820ccc7a90fffd139fe7666c1357a1504a8795f0c5db6"
  end

  def install
    system "cmake", "-S", "cpp", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17", # keep in sync with C++ standard in abseil.rb
                    "-DGTEST_INCLUDE_DIR=#{Formula["googletest"].opt_include}",
                      *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
