class Dscanner < Formula
  desc "Analyses e.g. the style and syntax of D code"
  homepage "https://github.com/dlang-community/D-Scanner"
  url "https://github.com/dlang-community/D-Scanner.git",
      tag:      "v0.12.1",
      revision: "e027965176499b578b297e8bead32a0400d07a6d"
  license "BSL-1.0"
  head "https://github.com/dlang-community/D-Scanner.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dscanner"
    sha256 cellar: :any_skip_relocation, mojave: "75a412f2ff1173a49df7eec1f536efd6bc236df975cac2f40f230bce2e04cceb"
  end

  if Hardware::CPU.arm?
    depends_on "ldc" => :build
  else
    depends_on "dmd" => :build
  end

  def install
    system "make", "all", "DC=#{Hardware::CPU.arm? ? "ldc2" : "dmd"}"
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
