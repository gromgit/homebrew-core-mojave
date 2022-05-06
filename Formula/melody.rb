class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "b9c7cacd6389fb32f5b75b5a6d47d171fafdac36fe5f23632ca24e52a052e361"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/melody"
    sha256 cellar: :any_skip_relocation, mojave: "9cb0574a43adcf543d81b10f408cb91020cc22de2315a8092b1d4481d6dc0c25"
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
