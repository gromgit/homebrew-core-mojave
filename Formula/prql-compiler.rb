class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.5.tar.gz"
  sha256 "0446ff0698ebb46b02ebb5481f4ab954562d56361b01040e9d6c2b7e251ece64"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/prql-compiler"
    sha256 cellar: :any_skip_relocation, mojave: "c3d619585de7e8beb6b4cb6e9dab7d52317ff5d0876a6ed525e15c946d455b96"
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
