class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.9.tar.gz"
  sha256 "b1cb4108d1d35c8e2d2630cdb78a42e1e10ff36ea00ce2e76577e1723905d4a2"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fselect"
    sha256 cellar: :any_skip_relocation, mojave: "1ab70e5ae94d3dcc7f621f1bef0df7e5c7db2238f2b99148199c18d0ce2b32a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
