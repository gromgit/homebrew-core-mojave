class OpusTools < Formula
  desc "Utilities to encode, inspect, and decode .opus files"
  homepage "https://www.opus-codec.org"
  url "https://archive.mozilla.org/pub/opus/opus-tools-0.2.tar.gz", using: :homebrew_curl
  sha256 "b4e56cb00d3e509acfba9a9b627ffd8273b876b4e2408642259f6da28fa0ff86"
  license "BSD-2-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opus-tools"
    sha256 cellar: :any, mojave: "d83dcbf5f954207a6a5a9ce806d69ff608e85e10d6adf3d7a412db5bb695485c"
  end

  head do
    url "https://gitlab.xiph.org/xiph/opus-tools.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libopusenc"
  depends_on "opus"
  depends_on "opusfile"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    cp test_fixtures("test.wav"), "test.wav"
    assert_match "Encoding complete", shell_output("#{bin}/opusenc test.wav enc.opus 2>&1")
    assert_predicate testpath/"enc.opus", :exist?, "Failed to encode to enc.opus"
    assert_match "Decoding complete", shell_output("#{bin}/opusdec enc.opus dec.wav 2>&1")
    assert_predicate testpath/"dec.wav", :exist?, "Failed to decode to dec.wav"
  end
end
