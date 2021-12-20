class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.14.tar.gz"
  sha256 "9da04f3b0ea53b50eae670d6014ff54c0df2cb40f6679b2f6a96840c1217f242"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kahip"
    sha256 cellar: :any, mojave: "b41980d03f13dd8f5cf33ce5ddaed4148733bd03a8ae5498603963608f128362"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  def install
    if OS.mac?
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      ENV["CC"] = Formula["gcc"].opt_bin/"gcc-#{gcc_major_ver}"
      ENV["CXX"] = Formula["gcc"].opt_bin/"g++-#{gcc_major_ver}"
    end

    mkdir "build" do
      system "cmake", *std_cmake_args, ".."
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
