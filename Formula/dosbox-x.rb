class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.83.24.tar.gz"
  sha256 "f4746f1524cac58756123c7acbbc565e215d7f298a19667fd845dbba040c6021"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dosbox-x"
    rebuild 1
    sha256 cellar: :any, mojave: "79334df762b00eff0db0eb89d0174299945fe0e4b5ea5c6e0a7d1dcde482f1f1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on macos: :high_sierra # needs futimens

  on_linux do
    depends_on "linux-headers@4.15" => :build
    depends_on "gcc"
    depends_on "sdl2"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-sdltest
    ]
    build_script = OS.mac? ? "./build-macosx" : "./build"
    system build_script, *args
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
