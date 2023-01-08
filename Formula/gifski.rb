class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.8.1.tar.gz"
  sha256 "9c06e0124a5bde4d70fe44cc8be52ffc9b9099548fc34cac1db43c4a6ff8783c"
  license "AGPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gifski"
    sha256 cellar: :any, mojave: "72b558d843ff8432419bcdf50c3c8af94e83653536302848df0e0054c95ca2f5"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
