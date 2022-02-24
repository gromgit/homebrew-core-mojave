class Pict < Formula
  desc "Pairwise Independent Combinatorial Tool"
  homepage "https://github.com/Microsoft/pict/"
  url "https://github.com/Microsoft/pict/archive/v3.7.3.tar.gz"
  sha256 "43279d0ea93c2c4576c049a67f13a845aa75ad1d70f1ce65535a89ba09daba33"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pict"
    sha256 cellar: :any_skip_relocation, mojave: "25082e7d2b10b6ab58ca6abfe9478975ccd70576f4937f56b63eb3d5b0c17b0f"
  end

  fails_with gcc: "5"

  resource "testfile" do
    url "https://gist.githubusercontent.com/glsorre/9f67891c69c21cbf477c6cedff8ee910/raw/84ec65cf37e0a8df5428c6c607dbf397c2297e06/pict.txt"
    sha256 "ac5e3561f9c481d2dca9d88df75b58a80331b757a9d2632baaf3ec5c2e49ccec"
  end

  def install
    system "make"
    bin.install "pict"
  end

  test do
    resource("testfile").stage testpath
    output = shell_output("#{bin}/pict pict.txt")
    assert_equal output.split("\n")[0], "LANGUAGES\tCURRIENCIES"
    assert_match "en_US\tGBP", output
    assert_match "en_US\tUSD", output
    assert_match "en_UK\tGBP", output
    assert_match "en_UK\tUSD", output
  end
end
