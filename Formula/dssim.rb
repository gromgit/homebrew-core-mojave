class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.0.tar.gz"
  sha256 "b671aec5b117adb6f9c636ef70ecafbd671caacf8b110098565c01bf5171118f"
  license "AGPL-3.0-or-later"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dssim"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "dd916ab12bbb642755b1f0d3a31cfa1304dba26cc139a4a6fc0a0c6ef8c67f5b"
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
