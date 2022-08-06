class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.21.tar.gz"
  sha256 "17385837070c6a312eae4717fe0bfdd259ce07b4b653b5c258b4389062df886d"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdbook"
    sha256 cellar: :any_skip_relocation, mojave: "1c17e28e1c569a45cc4f47c92ac00467828ae0cd777acccdcb883d0ca3d419a4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system bin/"mdbook", "build"
  end
end
