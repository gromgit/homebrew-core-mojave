class Simh < Formula
  desc "Portable, multi-system simulator"
  homepage "http://simh.trailing-edge.com/"
  url "https://github.com/simh/simh/archive/v3.12-2.tar.gz"
  version "3.12.2"
  sha256 "bd8b01c24e62d9ba930f41a7ae7c87bf0c1e5794e27ff689c1b058ed75ebc3e8"
  license "MIT"
  head "https://github.com/simh/simh.git", branch: "master"

  # At the time this check was added, the "latest" release on GitHub was several
  # versions behind the actual latest version, so we check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:-\d+)?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/simh"
    sha256 cellar: :any, mojave: "e54ca5141df5d792e0f11c8896453d94647fb35f69b9e275a133114fe4a7fe17"
  end

  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zlib"

  def install
    ENV.deparallelize unless build.head?
    inreplace "makefile", "GCC = gcc", "GCC = #{ENV.cc}"
    inreplace "makefile", "CFLAGS_O = -O2", "CFLAGS_O = #{ENV.cflags}"
    system "make", "all"
    bin.install Dir["BIN/*"]
    Dir["**/*.txt"].each do |f|
      (doc/File.dirname(f)).install f
    end
    (pkgshare/"vax").install Dir["VAX/*.{bin,exe}"]
  end

  test do
    assert_match(/Goodbye/, pipe_output("#{bin}/altair", "exit\n", 0))
  end
end
