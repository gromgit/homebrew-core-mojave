class Packr < Formula
  desc "Easy way to embed static files into Go binaries"
  homepage "https://github.com/gobuffalo/packr"
  url "https://github.com/gobuffalo/packr/archive/v2.8.2.tar.gz"
  sha256 "bb5e64442b3165b99d9efab7acdbefc0f8faab0204fbeae453d20a736c36960d"
  license "MIT"

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
