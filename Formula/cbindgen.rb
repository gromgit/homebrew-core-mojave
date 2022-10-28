class Cbindgen < Formula
  desc "Project for generating C bindings from Rust code"
  homepage "https://github.com/eqrion/cbindgen"
  url "https://github.com/eqrion/cbindgen/archive/refs/tags/v0.24.3.tar.gz"
  sha256 "5d693ab54acc085b9f2dbafbcf0a1f089737f7e0cb1686fa338c2aaa05dc7705"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cbindgen"
    sha256 cellar: :any_skip_relocation, mojave: "83762e7ac6b235382b40c1b032e5d413fc1d6f22f826f70b69698f69dd1e289d"
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
