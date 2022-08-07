class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.6.tar.gz"
  sha256 "e9a2fc904f2e115c715df80421c39e0f226b6750a56db96d994acfe9336ec219"
  license "Unlicense"

  livecheck do
    url "https://github.com/alexhallam/tv/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)(?:[._-]release)?["' >]}i)
    strategy :page_match
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tidy-viewer"
    sha256 cellar: :any_skip_relocation, mojave: "3a8293510455645435b6c8247b61217c00249ed607d71c80089779cddb756a1b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink "tidy-viewer" => "tv"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_match "first header", shell_output("#{bin}/tv #{testpath}/test.csv")
  end
end
