class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/dosbox-x-v0.84.0.tar.gz"
  sha256 "564fbf8f0ab090c8b32bc38637c8204358c386b9cbffcb4f99a81bc82fddbad7"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url :stable
    regex(/^dosbox-x[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dosbox-x"
    sha256 cellar: :any, mojave: "7c2e6ef5a62bdd174e4878cd553e98f1e0a56ad7043314313ad4a095c1dceb2b"
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
