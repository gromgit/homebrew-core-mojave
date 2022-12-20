class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.12.14.tar.gz"
  sha256 "ace6adea86c9f0430b6957710d51fa9b48b46224deb10ef215efc5f62fdfc831"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/typos-cli"
    sha256 cellar: :any_skip_relocation, mojave: "d3474ed615436971df064079763c40dfa49ddfb3d2e397832807854b92eccaab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
