class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.30.2.tar.gz"
  sha256 "6c7d2bcaea1433d977d8fed0b55b71c9d045a7cdf616e3cd2dce9007da753db3"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cmark"
    rebuild 1
    sha256 cellar: :any, mojave: "d76cfbba8800c3c1aa13f75ec99f6d1597b55ff0523aa83666107ed5a6ca963c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  conflicts_with "cmark-gfm", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
