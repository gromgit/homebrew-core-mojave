class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.12.tar.gz"
  sha256 "df923b94b552772d58b4c1f359b3f2e4a05f7f26ab4ebd00a0ab7d2579f4c257"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kahip"
    rebuild 1
    sha256 cellar: :any, mojave: "9fe6645ff5ef4c1d9c6f8ad408f132704bbd7c232fb780009009def823a25f7a"
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
