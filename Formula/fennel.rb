class Fennel < Formula
  desc "Lua Lisp Language"
  homepage "https://fennel-lang.org"
  url "https://github.com/bakpakin/Fennel/archive/1.0.0.tar.gz"
  sha256 "6f619832751af9c37835737cde5cf4475ff90e073ecef4671f9e4f8be2c121a7"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fennel"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "956f9cf02519e7edbad390a8633126a984eba636926f683500c8237e667ac7f5"
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
