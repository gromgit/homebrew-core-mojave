class Quill < Formula
  desc "C++14 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/v1.7.2.tar.gz"
  sha256 "e2153c6e25f3a6cee47c2a9edbabdace418f6d64f62cd701dfdae38d5892bb1b"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/quill"
    sha256 cellar: :any_skip_relocation, mojave: "d371c2f447deab6f8ca9e6e3accb4cc4548e5e3d962e5ef8a06ef071117c527b"
  end

  depends_on "cmake" => :build

  def install
    ENV.cxx11

    mkdir "quill-build" do
      args = std_cmake_args
      args << ".."
      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();
        quill::Handler* file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
        quill::Logger* logger = quill::create_logger("logger_bar", file_handler);
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
