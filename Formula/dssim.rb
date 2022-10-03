class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.3.tar.gz"
  sha256 "f536e2b798d1731f2bc3575c4c2283a25a02e092d22ea6a25c3c3a6a84564bac"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dssim"
    sha256 cellar: :any_skip_relocation, mojave: "b258778432a65b48b29c7516d381200234bae041656214dabed77a879ab04867"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
