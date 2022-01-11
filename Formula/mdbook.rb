class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.15.tar.gz"
  sha256 "fa7f217fb6be229c25be21ccb712af8d0012241b529d1bbacb8f5cac65fe0013"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdbook"
    sha256 cellar: :any_skip_relocation, mojave: "6c3473a014f545fd85c54a1327be87838e3c46a02f298190c34c18da01dce41e"
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
