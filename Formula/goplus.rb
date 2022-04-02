class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.0.39.tar.gz"
  sha256 "abc5ed80ccd5d233c0b90e82b6fa5aaa874c4fe50cc6fe0f30372f96f7e75677"
  license "Apache-2.0"
  revision 1
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goplus"
    sha256 mojave: "5e329b7391705dfd69fd5995b72e51ac511d79033a2b396eadc72627f9b7910a"
  end

  # Bump to 1.18 on the next release (1.1.0).
  depends_on "go@1.17"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    libexec.glob("bin/*").each do |file|
      (bin/file.basename).write_env_script(file, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
    end
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

    system Formula["go@1.17"].opt_bin/"go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
