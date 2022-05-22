class TidyViewer < Formula
  desc "CLI csv pretty printer"
  homepage "https://github.com/alexhallam/tv"
  url "https://github.com/alexhallam/tv/archive/refs/tags/1.4.5.tar.gz"
  sha256 "06906324bc510698651e57b1dfe9a28301ccbdd509f079bf09ce7f6d2f2fad2b"
  license "Unlicense"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tidy-viewer"
    sha256 cellar: :any_skip_relocation, mojave: "8cfd967ccd0fe9da24ad8621cefedc1ae3d70f83a2d77426efd2eec30969b9b2"
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
