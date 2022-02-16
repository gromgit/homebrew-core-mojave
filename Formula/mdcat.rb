class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://codeberg.org/flausch/mdcat"
  url "https://codeberg.org/flausch/mdcat/archive/mdcat-0.26.1.tar.gz"
  sha256 "1120c4f3b5b517075b6347dbfe76a2211a91837b4d0242c0b72cdbc19e6886dd"
  license "MPL-2.0"
  head "https://codeberg.org/flausch/mdcat.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdcat"
    sha256 cellar: :any_skip_relocation, mojave: "e0904267808dcf06861c7888ed35850fca556111b916356cb78aebae89845388"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
