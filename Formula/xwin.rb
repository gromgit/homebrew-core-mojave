class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.8.tar.gz"
  sha256 "2cca9d2833de9f2334907e86f86b6efbdea26578fc349add8644ad195149d6f8"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xwin"
    sha256 cellar: :any_skip_relocation, mojave: "2c4dc1d010c84567bc69bce8347c04d366c772729d595b12d7a510d9b9cbafbc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
