class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20210715.151551.e7ad03a.tar.gz"
  version "20210715.151551.e7ad03a"
  sha256 "546dcb5f3b625aff4f6bf22d27a0a636d15854fd729402a6933d31f3d0417e0d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atomicparsley"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9ac9a61d7847405d3562fdf83b6fb3790359e069e77b437f0bdc56bf3c03fddf"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
