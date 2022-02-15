class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.2.0.tar.gz"
  sha256 "b671aec5b117adb6f9c636ef70ecafbd671caacf8b110098565c01bf5171118f"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dssim"
    sha256 cellar: :any_skip_relocation, mojave: "b3dda6ba6ace6267c5614457d07b8775d15934a7be42295fdfcbc6557eb4d9ae"
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
