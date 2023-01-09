class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.4.0.tar.gz"
  sha256 "ba1fd89dd5a36a5443c879cd084b5626d3f8704000ec53c0d1cf5276af2bfa86"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gofumpt"
    sha256 cellar: :any_skip_relocation, mojave: "307f31f06102af6a3ccc34f6c25ce97f96b660e4f9a9ed5f201f630d8f8e1335"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # upstream issue tracker, https://github.com/mvdan/gofumpt/issues/253
    # assert_match version.to_s, shell_output("#{bin}/gofumpt --version")

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
