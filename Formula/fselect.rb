class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.8.tar.gz"
  sha256 "9ad3b7e2a8928ac5cf1694a72594ff56ab118dcb01803b780cdf70779355c000"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fselect"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "5975477eff5a39a44385a4af638d3dfa3250d5515bf37b61c2c5aefa4199626e"
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
