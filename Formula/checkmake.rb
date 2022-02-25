class Checkmake < Formula
  desc "Linter/analyzer for Makefiles"
  homepage "https://github.com/mrtazz/checkmake"
  url "https://github.com/mrtazz/checkmake/archive/refs/tags/0.2.1.tar.gz"
  sha256 "6e0d5237bc1de2a42ba1cf1a5c1da7d783bd9da06755e0c7faba6c3ba77ab1ee"
  license "MIT"
  head "https://github.com/mrtazz/checkmake.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/checkmake"
    sha256 cellar: :any_skip_relocation, mojave: "7fe031bc10e97693e19e35fe8247a8c5976d7de28e2fec5d1a409a22c12645ff"
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
