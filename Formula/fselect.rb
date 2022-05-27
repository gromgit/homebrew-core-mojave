class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.1.tar.gz"
  sha256 "1456dd9172903cd997e7ade6ba45b5937cfce023682a2ceb140201b608fbc628"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fselect"
    sha256 cellar: :any_skip_relocation, mojave: "74ed7a09b07ee23094e90f82cf1828bc23da264aea1b030eabe47106a2460e8d"
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
