class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/libsixel/libsixel/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "028552eb8f2a37c6effda88ee5e8f6d87b5d9601182ddec784a9728865f821e0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsixel"
    sha256 cellar: :any, mojave: "e954025776038a214cda8200e73d2676a906420001d336bc211709e9bc660724"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "jpeg"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "..", "-Dgdk-pixbuf2=disabled", "-Dtests=disabled"
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    fixture = test_fixtures("test.png")
    system "#{bin}/img2sixel", fixture
  end
end
