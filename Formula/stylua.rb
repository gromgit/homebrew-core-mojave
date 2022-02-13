class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.2.tar.gz"
  sha256 "5441c07126e3af38789b397dc2d345138440ad2a4baca3d87e2df1e7feec8f93"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stylua"
    sha256 cellar: :any_skip_relocation, mojave: "fe491dba4e52e6c0f436a23c7bb1b470ea4920e2ac5a7e98ebfa349e21e5ea02"
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
