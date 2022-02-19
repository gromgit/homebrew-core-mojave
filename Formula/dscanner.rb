class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.12.0",
      revision: "cdf881c10386bb9cf9115af80daa86a48e93833b"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dscanner"
    sha256 cellar: :any_skip_relocation, mojave: "5d7a5243e00e6f9931c3912c794e3ba78ba59652f396bdb7ab7e8ae7d6100234"
  end

  depends_on "dmd" => :build

  def install
    system "make", "dmdbuild"
    bin.install "bin/dscanner"
  end

  test do
    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main(string[] args)
      {
        writeln("Hello World");
      }
    EOS

    assert_match(/test.d:\t28\ntotal:\t28\n/, shell_output("#{bin}/dscanner --tokenCount test.d"))
  end
end
