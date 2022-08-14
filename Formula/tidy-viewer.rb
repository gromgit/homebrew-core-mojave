class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.30.tar.gz"
  sha256 "52beddc07283396c7fd30097dc2ea37b9f1872eee7f2d83546dc93dfe644747e"
  license "Unlicense"

  livecheck do
    url "https://github.com/alexhallam/tv/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)(?:[._-]release)?["' >]}i)
    strategy :page_match
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tidy-viewer"
    sha256 cellar: :any_skip_relocation, mojave: "4f58b3112a24033b66a326e1244ca8c501f2ff0c701caeaf0cdd69d7ac97e781"
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
