class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.1.0.tar.gz"
  sha256 "14873fb319ace8707a075bc4696d3691f5045686e5738822bdf4cc014d14b4b8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fennel"
    sha256 cellar: :any_skip_relocation, mojave: "4d5e9076d4a8764a12fb67775f802ca01857f76e6a8ff343286be228d3dfd179"
  end

  depends_on "lua"

  def install
    system "make"
    bin.install "fennel"

    lua = Formula["lua"]
    (share/"lua"/lua.version.major_minor).install "fennel.lua"
  end

  test do
    assert_match "hello, world!", shell_output("#{bin}/fennel -e '(print \"hello, world!\")'")
  end
end
