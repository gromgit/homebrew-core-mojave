class Libraqm < Formula
  desc "Library for complex text layout"
  homepage "https://github.com/HOST-Oman/libraqm"
  url "https://github.com/HOST-Oman/libraqm/archive/v0.10.0.tar.gz"
  sha256 "be25c6376888b6fb7168746fa3191e17a3b950045552bd9a6eef85f8353facc8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libraqm"
    sha256 cellar: :any, mojave: "50c09497b7ac81c6a12cbc5802477c95a9c39e37fdf8c86fce8ad50bd81535a7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "fribidi"
  depends_on "harfbuzz"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <raqm.h>

      int main() {
        return 0;
      }
    EOS

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["freetype"].include/"freetype2"}",
                   "-o", "test"
    system "./test"
  end
end
