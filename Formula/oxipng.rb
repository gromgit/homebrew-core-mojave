class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v6.0.1.tar.gz"
  sha256 "02625687bf19263bc2d537f9f81f85784c5b729c003e9dbb8551126d0e28ba7a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oxipng"
    sha256 cellar: :any_skip_relocation, mojave: "d8d3302a869b29784cebf2f30460a6066c4c0e347c9002aebeea493983eb807e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
