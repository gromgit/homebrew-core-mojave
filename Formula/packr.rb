class Packr < Formula
  desc "Easy way to embed static files into Go binaries"
  homepage "https://github.com/gobuffalo/packr"
  url "https://github.com/gobuffalo/packr/archive/v2.8.3.tar.gz"
  sha256 "67352bb3a73f6b183d94dd94f1b5be648db6311caa11dcfd8756193ebc0e2db9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/packr"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "16544ccda4874d2ec0d09566a1f868e497cff4b8fc88dd30f33429600c70dc6f"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args, "-o", bin/"packr2", "./packr2"
  end

  test do
    mkdir_p testpath/"templates/admin"

    (testpath/"templates/admin/index.html").write <<~EOS
      <!doctype html>
      <html lang="en">
      <head>
        <title>Example</title>
      </head>
      <body>
      </body>
      </html>
    EOS

    (testpath/"main.go").write <<~EOS
      package main

      import (
        "fmt"
        "log"

        "github.com/gobuffalo/packr/v2"
      )

      func main() {
        box := packr.New("myBox", "./templates")

        s, err := box.FindString("admin/index.html")
        if err != nil {
          log.Fatal(err)
        }

        fmt.Print(s)
      }
    EOS

    system "go", "mod", "init", "example"
    system "go", "mod", "edit", "-require=github.com/gobuffalo/packr/v2@v#{version}"
    system "go", "mod", "tidy"
    system "go", "mod", "download"
    system bin/"packr2"
    system "go", "build"
    system bin/"packr2", "clean"

    assert_equal File.read("templates/admin/index.html"), shell_output("./example")
  end
end
