class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.3.0.tar.gz"
  sha256 "41d88f985ca145d8f3fc3a02bfd92a8fd17aa9d581623f0b5d4b022ca88f2712"
  license "BSD-3-Clause"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gofumpt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "83f21d6e20b6433fde4418fb7586161a2a1ac1c51e7ece28fbc0364e67f81b80"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gofumpt --version")

    (testpath/"test.go").write <<~EOS
      package foo

      func foo() {
        println("bar")

      }
    EOS

    (testpath/"expected.go").write <<~EOS
      package foo

      func foo() {
      	println("bar")
      }
    EOS

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
