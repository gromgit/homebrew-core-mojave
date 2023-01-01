class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.5.tar.gz"
  sha256 "9e1b5546187290b265e43f47f67d4ce7bf817ae86ee2bc5fb338115b533f8438"
  license "MIT"
  revision 9

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cucumber-cpp"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "11d9c871c29c8c77c9aa4e181ca10e3466f940575be8377f96383e80f375a8c8"
  end

  depends_on "cmake" => :build
  depends_on "ruby" => :test
  depends_on "boost"

  def install
    args = std_cmake_args + %w[
      -DCUKE_DISABLE_GTEST=on
      -DCUKE_DISABLE_CPPSPEC=on
      -DCUKE_DISABLE_FUNCTIONAL=on
      -DCUKE_DISABLE_BOOST_TEST=on
      -DCMAKE_CXX_STANDARD=11
    ]

    system "cmake", ".", *args
    system "cmake", "--build", "."
    system "make", "install"
  end

  test do
    boost = Formula["boost"]
    ENV.prepend_path "PATH", Formula["ruby"].opt_bin
    ENV["GEM_HOME"] = testpath
    ENV["BUNDLE_PATH"] = testpath

    system "gem", "install", "cucumber", "-v", "5.2.0"

    (testpath/"features/test.feature").write <<~EOS
      Feature: Test
        Scenario: Just for test
          Given A given statement
          When A when statement
          Then A then statement
    EOS
    (testpath/"features/step_definitions/cucumber.wire").write <<~EOS
      host: localhost
      port: 3902
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include <cucumber-cpp/generic.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}",
           "-lcucumber-cpp", "-I#{boost.opt_include}",
           "-L#{boost.opt_lib}", "-lboost_regex", "-lboost_system",
           "-lboost_program_options", "-lboost_filesystem", "-lboost_chrono",
           "-pthread"
    begin
      pid = fork { exec "./test" }
      expected = <<~EOS
        Feature: Test

          Scenario: Just for test   # features/test.feature:2
            Given A given statement # test.cpp:2
            When A when statement   # test.cpp:4
            Then A then statement   # test.cpp:6

        1 scenario (1 passed)
        3 steps (3 passed)
      EOS
      assert_match expected, shell_output("#{testpath}/bin/cucumber --publish-quiet")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
