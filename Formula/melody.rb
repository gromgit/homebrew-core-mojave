class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "c68c05c0d87d4ab1069196f339043252fb1754395d8e5504f5295a2fadcc51d2"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/melody"
    sha256 cellar: :any_skip_relocation, mojave: "54d83af2c2cf8a34615b2f847335e9acf5a43820d389fd146d52dde268c26a48"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/melody_cli")
  end

  test do
    mdy = "regex.mdy"
    File.write mdy, '"#"; some of <word>;'
    assert_match "#\\w+", shell_output("#{bin}/melody --no-color #{mdy}")
  end
end
