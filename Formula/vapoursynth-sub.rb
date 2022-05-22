class VapoursynthSub < Formula
  desc "VapourSynth filters - Subtitling filter"
  homepage "https://www.vapoursynth.com"
  url "https://github.com/vapoursynth/subtext/archive/R3.tar.gz"
  sha256 "d0a1cf9bdbab5294eaa2e8859a20cfe162103df691604d87971a6eb541bebd83"
  license "MIT"
  version_scheme 1

  head "https://github.com/vapoursynth/subtext.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vapoursynth-sub"
    sha256 cellar: :any, mojave: "997d82d47fcaebe1a8d4ee18ef731fce4603b798d49bb08b5d440f460bb51451"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libass"
  depends_on "vapoursynth"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    # A meson-based install method has been added but is not present
    # in this release. Switch to it in the next release to avoid
    # manually installing the shared library.
    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"
    (lib/"vapoursynth").install "build/#{shared_library("libsubtext")}"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "from vapoursynth import core; core.sub"
  end
end
