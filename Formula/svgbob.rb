class Svgbob < Formula
  desc "Convert your ascii diagram scribbles into happy little SVG"
  homepage "https://ivanceras.github.io/svgbob-editor/"
  url "https://github.com/ivanceras/svgbob/archive/0.6.4.tar.gz"
  sha256 "b609542317ddd7adac69b038cca7478849ee0012a3fa18caa8fae2748918c051"
  license "Apache-2.0"
  head "https://github.com/ivanceras/svgbob.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/svgbob"
    sha256 cellar: :any_skip_relocation, mojave: "830fcb55a78152fce155afc108fd06cbf350427967dc3ee207abf5555bc6f990"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/cli")
    # The cli tool was renamed (0.6.2 -> 0.6.3)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"svgbob_cli" => "svgbob"
  end

  test do
    (testpath/"ascii.txt").write <<~EOS
      +------------------+
      |                  |
      |  Hello Homebrew  |
      |                  |
      +------------------+
    EOS

    system bin/"svgbob", "ascii.txt", "-o", "out.svg"
    contents = (testpath/"out.svg").read
    assert_match %r{<text.*?>Hello</text>}, contents
    assert_match %r{<text.*?>Homebrew</text>}, contents
  end
end
