class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.7.tar.gz"
  sha256 "955dde62493e9e58e9b06d80e6592f08b97c0d1cc701c3a9dc868f02e2f2f369"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/prql-compiler"
    sha256 cellar: :any_skip_relocation, mojave: "a2dffea72d96f9e398ca46d4606055da5201d240f6202606f141a58449598345"
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
