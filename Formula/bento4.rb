class Bento4 < Formula
  desc "Full-featured MP4 format and MPEG DASH library and tools"
  homepage "https://www.bento4.com/"
  url "https://www.bok.net/Bento4/source/Bento4-SRC-1-6-0-639.zip"
  version "1.6.0-639"
  sha256 "3c6be48e38e142cf9b7d9ff2713e84db4e39e544a16c6b496a6c855f0b99cc56"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.bok.net/Bento4/source/"
    regex(/href=.*?Bento4-SRC[._-]v?(\d+(?:[.-]\d+)+)\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bento4"
    sha256 cellar: :any_skip_relocation, mojave: "5046d46b28a39544aba3236bda55537676bf762e2f51655749f46b1bd9c2fde5"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10"

  conflicts_with "gpac", because: "both install `mp42ts` binaries"
  conflicts_with "mp4v2", because: "both install `mp4extract` and `mp4info` binaries"

  # Add support for cmake install.
  # TODO: Remove in the next release.
  patch do
    url "https://github.com/axiomatic-systems/Bento4/commit/ba95f55c495c4c34c75a95de843acfa00f6afe24.patch?full_index=1"
    sha256 "ba5984a122fd3971b40f74f1bb5942c34eeafb98641c32649bbdf5fe574256c5"
  end

  def install
    system "cmake", "-S", ".", "-B", "cmakebuild", *std_cmake_args
    system "cmake", "--build", "cmakebuild"
    system "cmake", "--install", "cmakebuild"

    rm Dir["Source/Python/wrappers/*.bat"]
    inreplace Dir["Source/Python/wrappers/*"],
              "BASEDIR=$(dirname $0)", "BASEDIR=#{libexec}/Python/wrappers"
    libexec.install "Source/Python"
    bin.install_symlink Dir[libexec/"Python/wrappers/*"]
  end

  test do
    system "#{bin}/mp4mux", "--track", test_fixtures("test.m4a"), "out.mp4"
    assert_predicate testpath/"out.mp4", :exist?, "Failed to create out.mp4!"
  end
end
