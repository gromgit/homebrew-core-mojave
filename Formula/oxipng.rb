class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v5.0.1.tar.gz"
  sha256 "aff72d2f627617f3f36d9796e65b83eb34f24d2c94f3a55612ade2df8ab8d946"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oxipng"
    sha256 cellar: :any_skip_relocation, mojave: "e05a80f677e273ecc105be83574a3047a87cd141b9b38849c9032cc0c864d6a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
