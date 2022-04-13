class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.17.tar.gz"
  sha256 "9523d0bed63ce35eec5a8259eb963651cd7e37ec5644ef551134068a2fb72f89"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mdbook"
    sha256 cellar: :any_skip_relocation, mojave: "e29fda879cefb897b146409d6163add990f9b223776ff7c1351461cde9a474f6"
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
