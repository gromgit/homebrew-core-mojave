class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.0.tar.gz"
  sha256 "33dfcbbf7e598bce479b1fb5c17429af1bb309beab2e4bc95642e9f4b5c2ffbd"
  license any_of: ["Apache-2.0", "MIT"]

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fselect"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2406c6c57e4fc488bb213009d29a76f3de24658d927e6f50053717b27eb8eb2e"
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
