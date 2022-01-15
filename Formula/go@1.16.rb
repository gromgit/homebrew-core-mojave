class GoAT116 < Formula
  desc "Go programming environment (1.16)"
  homepage "https://golang.org"
  url "https://golang.org/dl/go1.16.13.src.tar.gz"
  mirror "https://fossies.org/linux/misc/go1.16.13.src.tar.gz"
  sha256 "b0926654eaeb01ef43816638f42d7b1681f2d3f41b9559f07735522b7afad41a"
  license "BSD-3-Clause"

  livecheck do
    url "https://golang.org/dl/"
    regex(/href=.*?go[._-]?v?(1\.16(?:\.\d+)*)[._-]src\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/go@1.16"
    sha256 cellar: :any_skip_relocation, mojave: "3df4f6abc2f76b39a7c951acdc89da8bbde56627893540c3792ab6c6939fd8ca"
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
