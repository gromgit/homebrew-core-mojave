class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1745",
      revision: "72eb0e6b6fe2863be24650414a34ad504f56f2f8"
  version "r1745"
  license "ISC"
  version_scheme 1
  head "https://github.com/vgmstream/vgmstream.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=["']?[^"' >]*?/tag/([^"' >]+)["' >]}i)
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vgmstream"
    sha256 cellar: :any, mojave: "ca4670baf39114e2ea9e631aeff6bc7dcc240608c61a4e693fed283737208f4e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    ENV["LIBRARY_PATH"] = HOMEBREW_PREFIX/"lib"
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    bin.install "build/cli/vgmstream-cli", "build/cli/vgmstream123"
    lib.install "build/src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
