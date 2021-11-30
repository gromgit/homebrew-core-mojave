class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.14.tar.gz"
  sha256 "59fd3e417e9d09deac89e20467194dd9f93854c2f1a87e845816c5cec676765c"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

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
