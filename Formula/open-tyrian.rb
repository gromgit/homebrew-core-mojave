class OpenTyrian < Formula
  desc "Open-source port of Tyrian"
  homepage "https://github.com/opentyrian/opentyrian"
  url "https://github.com/opentyrian/opentyrian/archive/refs/tags/v2.1.20220318.tar.gz"
  sha256 "e0c6afbb5d395c919f9202f4c9b3b4da7bd6e993e9da6152f995012577e1ccbd"
  license "GPL-2.0-or-later"
  head "https://github.com/opentyrian/opentyrian.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/open-tyrian"
    sha256 mojave: "f9b334efd7ff761bd278cad82dafdc0cbf252f0d9e8576dfead2af68c9ef1d7b"
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "sdl2_net"

  resource "homebrew-test-data" do
    url "https://camanis.net/tyrian/tyrian21.zip"
    sha256 "7790d09a2a3addcd33c66ef063d5900eb81cc9c342f4807eb8356364dd1d9277"
  end

  def install
    datadir = pkgshare/"data"
    datadir.install resource("homebrew-test-data")
    system "make", "TYRIAN_DIR=#{datadir}"
    bin.install "opentyrian"
  end

  def caveats
    "Save games will be put in ~/.opentyrian"
  end

  test do
    system "#{bin}/opentyrian", "--help"
  end
end
