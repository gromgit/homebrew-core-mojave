class Vgmstream < Formula
  desc "Library for playing streamed audio formats from video games"
  homepage "https://vgmstream.org"
  url "https://github.com/vgmstream/vgmstream.git",
      tag:      "r1667",
      revision: "6b84f258e4238edd627e24ec8460a7040613d054"
  version "r1667"
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
    sha256 mojave: "4315d798cf28f06bb267cbc8ed8ba8420701b942754bcb765a7d3de5ca3f979f"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "jansson"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mpg123"

  def install
    system "cmake", "-DBUILD_AUDACIOUS:BOOL=OFF", *std_cmake_args, "."
    system "cmake", "--build", ".", "--config", "Release", "--target", "vgmstream_cli", "vgmstream123"
    bin.install "cli/vgmstream-cli"
    bin.install "cli/vgmstream123"
    lib.install "src/libvgmstream.a"
  end

  test do
    assert_match "decode", shell_output("#{bin}/vgmstream-cli 2>&1", 1)
  end
end
