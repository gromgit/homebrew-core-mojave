class Qtads < Formula
  desc "TADS multimedia interpreter"
  homepage "https://realnc.github.io/qtads/"
  url "https://github.com/realnc/qtads/releases/download/v3.3.0/qtads-3.3.0-source.tar.xz"
  sha256 "02d62f004adbcf1faaa24928b3575a771d289df0fea9a97705d3bc528d9164a1"
  license "GPL-3.0-or-later"
  head "https://github.com/realnc/qtads.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/qtads"
    sha256 cellar: :any, mojave: "770092fbd56131d57ba2d7abf25cd1a2f7baaf3cd10dd69d3838db5e414d0cdb"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "qt@5"
  depends_on "sdl2"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    sdl_sound_include = Formula["sdl_sound"].opt_include
    inreplace "qtads.pro",
      "$$T3DIR \\",
      "$$T3DIR #{sdl_sound_include}/SDL \\"

    args = ["DEFINES+=NO_STATIC_TEXTCODEC_PLUGINS"]
    args << "PREFIX=#{prefix}" unless OS.mac?

    system "qmake", *args
    system "make"

    if OS.mac?
      prefix.install "QTads.app"
      bin.write_exec_script "#{prefix}/QTads.app/Contents/MacOS/QTads"
    else
      system "make", "install"
    end

    man6.install "desktop/man/man6/qtads.6"
  end

  test do
    bin_name = OS.mac? ? "QTads" : "qtads"
    assert_predicate testpath/"#{bin}/#{bin_name}", :exist?, "I'm an untestable GUI app."
  end
end
