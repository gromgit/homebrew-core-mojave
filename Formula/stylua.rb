class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.3.tar.gz"
  sha256 "c7c960d501535329e007ff9757067d40b0cf395c2fceac09e169f4c9ea8e67ca"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stylua"
    sha256 cellar: :any_skip_relocation, mojave: "502aaf8044338db34015a2c6d519342eaaa0ff699d5c479a5ff2c4e70a955f30"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--all-features", *std_cargo_args
  end

  test do
    (testpath/"test.lua").write("local  foo  = {'bar'}")
    system bin/"stylua", "test.lua"
    assert_equal "local foo = { \"bar\" }\n", (testpath/"test.lua").read
  end
end
