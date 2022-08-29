class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.2.0.tar.gz"
  sha256 "a0c9b1d23d9d9714afe93542c5314fad8e1771bf8b616d0decfeabe88318313e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fennel"
    sha256 cellar: :any_skip_relocation, mojave: "9f26ea712b05fce128ba65049e878a657f66ac2091dc62a01bcc82a82f557187"
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
