class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2021.1.2.tar.gz"
  sha256 "c3fcadc203e20bc029abc9fc1d97b789de4e90dd8164e45489ec52f401a2bfd0"
  license "MIT"
  revision 1
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/staticcheck"
    sha256 cellar: :any_skip_relocation, mojave: "9fa5c0ad3be0f0c800346da0b584b668966e49eb78ec6afecdf6ac72fa1a133b"
  end

  # Bump to 1.18 on the next release.
  depends_on "go@1.17"

  def install
    output = libexec/"bin/staticcheck"
    system "go", "build", *std_go_args(output: output), "./cmd/staticcheck"
    (bin/"staticcheck").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        var x uint
        x = 1
        fmt.Println(x)
      }
    EOS
    json_output = JSON.parse(shell_output("#{bin}/staticcheck -f json test.go", 1))
    assert_equal json_output["code"], "S1021"
  end
end
