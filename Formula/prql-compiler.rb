class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.6.tar.gz"
  sha256 "4079d5f505250e6fe071215499b21e8ac7ecea23b55a16a4054bc5bf5707faf6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/prql-compiler"
    sha256 cellar: :any_skip_relocation, mojave: "a03e2e03a30e2ecf8f433cb47817cca4df45eb90924bfe6f5e615a15044f3d9f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
