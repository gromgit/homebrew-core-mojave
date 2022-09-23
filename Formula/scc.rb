class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v3.1.0.tar.gz"
  sha256 "bffea99c7f178bc48bfba3c64397d53a20a751dfc78221d347aabdce3422fd20"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scc"
    sha256 cellar: :any_skip_relocation, mojave: "a2d5f764edea42db8c5b7cbe4f38342aceeaa365f1134d2e2d321e170f507bdd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes
      C,4,4,0,0,0,50
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
