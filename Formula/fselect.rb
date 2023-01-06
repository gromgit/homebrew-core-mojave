class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.1.tar.gz"
  sha256 "1456dd9172903cd997e7ade6ba45b5937cfce023682a2ceb140201b608fbc628"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fselect"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4efaae693dc74db11bd01b0be87092c438511aaad17038eeba52f4e3fb73473e"
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
