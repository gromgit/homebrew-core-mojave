class Blink1 < Formula
  desc "Control blink(1) indicator light"
  homepage "https://blink1.thingm.com/"
  url "https://github.com/todbot/blink1-tool.git",
      tag:      "v2.3.0",
      revision: "69561a9ed9e83ff67c95cc70187c394150f51cd5"
  license "CC-BY-SA-3.0"
  head "https://github.com/todbot/blink1-tool.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/blink1"
    sha256 cellar: :any, mojave: "c73f771ecbf47ae069a73cf329def05632e996848dd5470c896be5733ed862e2"
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "systemd"
  end

  def install
    system "make"
    bin.install "blink1-tool"
    include.install "blink1-lib.h"
    library = OS.mac? ? "libBlink1.dylib" : "libblink1.so"
    lib.install library
  end

  test do
    system bin/"blink1-tool", "--version"
  end
end
