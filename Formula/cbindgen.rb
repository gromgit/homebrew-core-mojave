class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/eqrion/cbindgen"
  url "https://github.com/eqrion/cbindgen/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "5d693ab54acc085b9f2dbafbcf0a1f089737f7e0cb1686fa338c2aaa05dc7705"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cbindgen"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5840faeb81909ea1f9bd7078b9e552e7b83ae08e6e83eade1bebd36e1fc38f8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/rust/extern.rs", testpath
    output = shell_output("#{bin}/cbindgen extern.rs")
    assert_match "extern int32_t foo()", output
  end
end
