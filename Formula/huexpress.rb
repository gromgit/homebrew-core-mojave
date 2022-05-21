class Huexpress < Formula
  desc "PC Engine emulator"
  homepage "https://github.com/kallisti5/huexpress"
  url "https://github.com/kallisti5/huexpress/archive/3.0.4.tar.gz"
  sha256 "76589f02d1640fc5063d48a47f017077c6b7557431221defe9e38679d86d4db8"
  license "GPL-2.0"
  revision 2
  head "https://github.com/kallisti5/huexpress.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/huexpress"
    sha256 cellar: :any, mojave: "ce616624311bad981def3bd5bdef198592d24974fa579eb0cf9888494c1b14b3"
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "libvorbis"
  depends_on "libzip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    # Don't statically link to libzip.
    inreplace "src/SConscript", "pkg-config --cflags --libs --static libzip", "pkg-config --cflags --libs libzip"
    system "scons"
    bin.install ["src/huexpress", "src/hucrc"]
  end

  test do
    assert_match(/Version #{version}$/, shell_output("#{bin}/huexpress -h", 1))
  end
end
