class Stylua < Formula
  desc "Opinionated Lua code formatter"
  homepage "https://github.com/JohnnyMorganz/StyLua"
  url "https://github.com/JohnnyMorganz/StyLua/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "f9f57d52a5665c4c878556e14b8533da053d64a55575fbc92e4445c5a064bd4f"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stylua"
    sha256 cellar: :any_skip_relocation, mojave: "6a24f52edb5fc1e5427e8465283425e5c52cb9e2873b76122fc1887b94140a8a"
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
