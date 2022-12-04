class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "https://libsndfile.github.io/libsndfile/"
  url "https://github.com/libsndfile/libsndfile/releases/download/1.1.0/libsndfile-1.1.0.tar.xz"
  sha256 "0f98e101c0f7c850a71225fb5feaf33b106227b3d331333ddc9bacee190bcf41"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsndfile"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c5bb17196653f3ec34f4b209149ee94f07d39e9543236e66c8b43eeee22d5ade"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opus"

  uses_from_macos "python" => :build

  # Fix unsubstituted variable @EXTERNAL_MPEG_LIBS@ in sndfile.pc
  # PR ref: https://github.com/libsndfile/libsndfile/pull/828
  # Remove in the next release.
  patch do
    url "https://github.com/libsndfile/libsndfile/commit/e4fdaeefddd39bae1db27d48ccb7db7733e0c009.patch?full_index=1"
    sha256 "af1e9faf1b7f414ff81ef3f1641e2e37f3502f0febd17f70f0db6ecdd02dc910"
  end

  def install
    system "autoreconf", "-fvi"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/sndfile-info #{test_fixtures("test.wav")}")
    assert_match "Duration    : 00:00:00.064", output
  end
end
