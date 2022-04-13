class Melody < Formula
  desc "Language that compiles to regular expressions"
  homepage "https://yoav-lavi.github.io/melody/book"
  url "https://github.com/yoav-lavi/melody/archive/refs/tags/v0.13.10.tar.gz"
  sha256 "1922d6d668d2107c83f9fa729a1e37701920296640b5fce14a732c62840ffd00"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/melody"
    sha256 cellar: :any_skip_relocation, mojave: "5727f6afdf47851b0f83548cda1620c17529097480956b57449251f0907888fa"
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
