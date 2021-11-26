class Gosec < Formula
  desc "Golang security checker"
  homepage "https://securego.io/"
  url "https://github.com/securego/gosec/archive/v2.9.2.tar.gz"
  sha256 "626cd3c2bef1eb3ea0838b3e9cd81a0db74fbd6a1557ee3c74add3fad24010f1"
  license "Apache-2.0"
  head "https://github.com/securego/gosec.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gosec"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f234d41b1a092420d4198f2fd503fe25815b70e913a53ee32065ef320b5a072e"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.version=v#{version}", "./cmd/gosec"
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
