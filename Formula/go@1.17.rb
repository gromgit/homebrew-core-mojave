class GoAT117 < Formula
  desc "Go programming environment (1.17)"
  homepage "https://golang.org"
  url "https://go.dev/dl/go1.17.10.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.17.10.src.tar.gz"
  sha256 "299e55af30f15691b015d8dcf8ecae72412412569e5b2ece20361753a456f2f9"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.17(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/go@1.17"
    sha256 cellar: :any_skip_relocation, mojave: "29daafbec4979b55a7029b656107b3438fe8a8b5b00b7b4af962b61cad10b3c0"
  end

  keg_only :versioned_formula

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
    (libexec/"src/debug/elf/testdata").rmtree
    # Binaries built for an incompatible architecture
    (libexec/"src/runtime/pprof/testdata").rmtree
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
        fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    ENV["GOOS"] = "freebsd"
    ENV["GOARCH"] = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    system bin/"go", "build", "hello.go"
  end
end
