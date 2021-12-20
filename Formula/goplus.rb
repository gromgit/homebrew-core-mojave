class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.36.tar.gz"
  sha256 "d42a9bb5ca1eac3afcee149f585d2ef7737e595619e5b76f2cca79f5b9c8019f"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goplus"
    sha256 mojave: "e34b8f7360eb7b1e52bbd4bc19e4f7c9c1db8dd2eedaafe340b056878cdd8f61"
  end

  depends_on "go"

  def install
    # Patch version to match the version of gop, currently it get version from git tag
    inreplace "env/version.go", /^\tbuildVersion string$/, "\tbuildVersion string = \"v#{version}\"" unless build.head?

    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
