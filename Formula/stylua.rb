class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "e870551aab62194b92fcb73607c7b7f6e4a41ad75a64e67f18e5ce0a6c608573"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stylua"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c7b08eb3e7645750438c0356c0f523ca0d1cc0b6de4631d2e4d8f37aa76adfd1"
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
