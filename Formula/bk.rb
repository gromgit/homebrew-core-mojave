class Bk < Formula
  desc "Terminal EPUB Reader"
  homepage "https://github.com/aeosynth/bk"
  url "https://github.com/aeosynth/bk/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "c9c54fa2cd60f3ca0576cab8bdd95b74da4d80c109eb91b5426e7ee0575b54f1"
  license "MIT"
  head "https://github.com/aeosynth/bk.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bk"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "e3217eeca92340b9e472fba02bffa08ca439d8f18966f02113106531ab9388db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_epub = test_fixtures("test.epub")
    output = pipe_output("#{bin}/bk --meta #{test_epub}")
    assert_match "language: en", output
  end
end
