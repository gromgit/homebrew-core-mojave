class GoBoring < Formula
  desc "Go programming language with BoringCrypto"
  homepage "https://go.googlesource.com/go/+/dev.boringcrypto/README.boringcrypto.md"
  url "https://go-boringcrypto.storage.googleapis.com/go1.17.6b7.src.tar.gz"
  version "1.17.6b7"
  sha256 "5178f595dea6d618f7cdf6b9e2346a1a28430b4d547996b766fcd5b34379ca2f"
  license "BSD-3-Clause"

  livecheck do
    url "https://go-boringcrypto.storage.googleapis.com/"
    regex(/>go[._-]?(\d+(?:\.\d+)+b\d+)[._-]src\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/go-boring"
    sha256 mojave: "c30e2e365e9dd76cdf45876430b636ddf8a1beff5989bdbe8c2de024516da9a0"
  end

  keg_only "it conflicts with the Go formula"

  depends_on "go" => :build

  def install
    ENV["GOROOT_BOOTSTRAP"] = Formula["go"].opt_libexec

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    system bin/"go", "install", "-race", "std"

    # Remove useless files.
    # Breaks patchelf because folder contains weird debug/test files
    Dir.glob(libexec/"**/testdata").each { |testdata| rm_rf testdata }
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import (
          "fmt"
          _ "crypto/tls/fipsonly"
      )

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = "amd64"
    system bin/"go", "build", "hello.go"
  end
end
