class Logswan < Formula
  desc "Fast Web log analyzer using probabilistic data structures"
  homepage "https://www.logswan.org"
  url "https://github.com/fcambus/logswan/archive/2.1.11.tar.gz"
  sha256 "a031b04c2dcfe8195e4225b8dd5781fc76098b9d19d0e4a9cbe1da76a4928eea"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/logswan"
    rebuild 1
    sha256 cellar: :any, mojave: "ac4ce3dd43e7e46af8d1fd9f2c1f353e79b0a6e3dc1d654445f5028a7c290311"
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
