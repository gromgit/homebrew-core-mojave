class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v5.0.1.tar.gz"
  sha256 "aff72d2f627617f3f36d9796e65b83eb34f24d2c94f3a55612ade2df8ab8d946"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oxipng"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f87582baebc090270fe3166d3b2816daebeb96ca2fd20b2c10610ca7efdcca72"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
