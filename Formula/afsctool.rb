class Afsctool < Formula
  desc "Utility for manipulating APFS and ZFS compressed files"
  homepage "https://brkirch.wordpress.com/afsctool/"
  url "https://github.com/RJVB/afsctool/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "5776ff5aaf05c513bead107536d9e98e6037019a0de8a1435cc9da89ea8d49b8"
  license all_of: ["GPL-3.0-only", "BSL-1.0"]
  head "https://github.com/RJVB/afsctool.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/afsctool"
    sha256 cellar: :any_skip_relocation, mojave: "8bcf62e25d7e296fdc797d932e467f0dc65f220850872db239725eb3a126376c"
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
