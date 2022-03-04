class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/mrtazz/checkmake"
  url "https://github.com/mrtazz/checkmake/archive/refs/tags/0.2.1.tar.gz"
  sha256 "6e0d5237bc1de2a42ba1cf1a5c1da7d783bd9da06755e0c7faba6c3ba77ab1ee"
  license "MIT"
  head "https://github.com/mrtazz/checkmake.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/checkmake"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1d512399242e39940022f8593eac8b508946f11b1d8882d3c4c717fc8ebe33a8"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  def install
    ENV["BUILDER_NAME"] = "Homebrew"
    ENV["BUILDER_EMAIL"] = "homebrew@brew.sh"
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    sh = testpath/"Makefile"
    sh.write <<~EOS
      clean:
      \trm bar
      \trm foo

      foo: bar
      \ttouch foo

      bar:
      \ttouch bar

      all: foo

      test:
      \t@echo test

      .PHONY: clean test
    EOS
    assert_match "phonydeclared", shell_output("#{bin}/checkmake #{sh}", 2)
  end
end
