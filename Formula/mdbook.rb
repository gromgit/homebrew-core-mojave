class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.18.tar.gz"
  sha256 "ce357327f4443189fde307103f8008f43410ca8b738c5c61401ada9a54b8b5b5"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdbook"
    sha256 cellar: :any_skip_relocation, mojave: "e657d7f84f1e4b19427c2bc286ad51fa6a31cdd1b4ba56c229ad687fb704ff67"
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
