class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.11.tar.gz"
  sha256 "a031b04c2dcfe8195e4225b8dd5781fc76098b9d19d0e4a9cbe1da76a4928eea"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logswan"
    rebuild 2
    sha256 cellar: :any, mojave: "60a3f8b90362887d7f811a6e86502046d42fb5d01a0da05c5247f5990a66df57"
  end

  depends_on "cmake" => :build
  depends_on "jansson"
  depends_on "libmaxminddb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    assert_match "visits", shell_output("#{bin}/logswan #{pkgshare}/examples/logswan.log")
  end
end
