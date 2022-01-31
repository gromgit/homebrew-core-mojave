class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.3.tar.gz"
  sha256 "e308eb088d059d18119dc757c98487d9cabc2f4b97035a8dc9f8253717aa9fe9"
  license "Unlicense"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tidy-viewer"
    sha256 cellar: :any_skip_relocation, mojave: "c1bdda267396266b3c4da2470391186c0ac692c18611a360949d8ef9a9278f23"
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
