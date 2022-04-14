class Staticcheck < Formula
  desc "State of the art linter for the Go programming language"
  homepage "https://staticcheck.io/"
  url "https://github.com/dominikh/go-tools/archive/2022.1.tar.gz"
  sha256 "aecfced0299fc70d17fc7d8d8dc87590429081250f03cb4c6bdd378fd50353ab"
  license "MIT"
  head "https://github.com/dominikh/go-tools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/staticcheck"
    sha256 cellar: :any_skip_relocation, mojave: "ba842fdd7fa7f1c62c9616e0c1e8cd06c339e57afdd58ffc4b125ceef2840a91"
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
