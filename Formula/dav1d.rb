class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.0.0/dav1d-1.0.0.tar.bz2"
  sha256 "4a4eb6cecbc8c26916ef58886d478243de8bcc46710b369c04d6891b0155ac0f"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dav1d"
    sha256 cellar: :any, mojave: "3f28f53a857247cabc64a5fe8a0be9bdd1cbcfb197b47134e4df947b7a459401"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  resource "00000000.ivf" do
    url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.0.0/8-bit/data/00000000.ivf"
    sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
  end

  def install
    system "meson", *std_meson_args, "build"
    system "ninja", "install", "-C", "build"
  end

  test do
    testpath.install resource("00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
