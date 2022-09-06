class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/libsixel/libsixel/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "028552eb8f2a37c6effda88ee5e8f6d87b5d9601182ddec784a9728865f821e0"
  revision 1
  head "https://github.com/libsixel/libsixel.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsixel"
    sha256 cellar: :any, mojave: "e03fe2bdcebed5c2164b6e4fec771717a9f45c05c0ab95a542f10b6120ecdf5d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "meson", *std_meson_args, "build", "-Dgdk-pixbuf2=disabled", "-Dtests=disabled"
    system "meson", "compile", "-C", "build", "-v"
    system "meson", "install", "-C", "build"
  end

  test do
    fixture = test_fixtures("test.png")
    system "#{bin}/img2sixel", fixture
  end
end
