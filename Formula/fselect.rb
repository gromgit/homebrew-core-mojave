class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.8.tar.gz"
  sha256 "9ad3b7e2a8928ac5cf1694a72594ff56ab118dcb01803b780cdf70779355c000"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fselect"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ea560a9543f9921b2073ecad7cc781b0ccbc9d58c290709487394a2915407f36"
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
