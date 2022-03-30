class Afsctool < Formula
  desc "Utility for manipulating APFS and ZFS compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://github.com/RJVB/afsctool/archive/refs/tags/1.7.2.tar.gz"
  sha256 "a0d01953e36a333c29369a126a81b905b70a5603533caeebc2f04bbd3aa1b0df"
  license all_of: ["GPL-3.0-only", "BSL-1.0"]
  head "https://github.com/RJVB/afsctool.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/afsctool"
    sha256 cellar: :any_skip_relocation, mojave: "0655c23a93444b72e7c734237442cd4f7b5e96fde110a0a5d029864c59ccb59c"
  end

  depends_on "cmake" => :build
  depends_on "google-sparsehash" => :build
  depends_on "pkg-config" => :build
  depends_on :macos

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", "."
    bin.install "afsctool"
    bin.install "zfsctool"
  end

  test do
    path = testpath/"foo"
    path.write "some text here."
    system "#{bin}/afsctool", "-c", path
    system "#{bin}/afsctool", "-v", path

    system "#{bin}/zfsctool", "-c", path
    system "#{bin}/zfsctool", "-v", path
  end
end
