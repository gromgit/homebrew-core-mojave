class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https://github.com/twogood/unshield"
  url "https://github.com/twogood/unshield/archive/1.5.1.tar.gz"
  sha256 "34cd97ff1e6f764436d71676e3d6842dc7bd8e2dd5014068da5c560fe4661f60"
  license "MIT"
  head "https://github.com/twogood/unshield.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/unshield"
    sha256 mojave: "603db0951be78a7c4d69cf3f7dc8318582923492b2d9e4cc991481c1b3c0e5aa"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"unshield", "-V"
  end
end
