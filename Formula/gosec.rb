class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.9.5.tar.gz"
  sha256 "7c6fd7e05e8ae8b8c8816616f61cf334f44e17dff0b3b1294daea0f04aa92f01"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gosec"
    sha256 cellar: :any_skip_relocation, mojave: "0ce394ca610fd3170cda417e73cd16c8ef83e78f99071611d7f640d2a23d2163"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/gosec"
  end

  test do
    (testpath/"test.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          username := "admin"
          var password = "f62e5bcda4fae4f82370da0c6f20697b8f8447ef"

          fmt.Println("Doing something with: ", username, password)
      }
    EOS

    output = shell_output("#{bin}/gosec ./...", 1)
    assert_match "G101 (CWE-798)", output
    assert_match "Issues : \e[1;31m1\e[0m", output
  end
end
