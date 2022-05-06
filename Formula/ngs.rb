class Ngs < Formula
  desc "Powerful programming language and shell designed specifically for Ops"
  homepage "https://ngs-lang.org/"
  url "https://github.com/ngs-lang/ngs/archive/v0.2.14.tar.gz"
  sha256 "9432377548ef76c57918b020b2abb258137703ff0172016d58d713186fcafed3"
  license "GPL-3.0-only"
  head "https://github.com/ngs-lang/ngs.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ngs"
    sha256 cellar: :any, mojave: "3cee1437e12525bba3b78dd8a56ee66c4d5c7d792b030703d4db15ea80420733"
  end

  depends_on "cmake" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gnu-sed"
  depends_on "json-c"
  depends_on "pcre"
  depends_on "peg"

  uses_from_macos "libffi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    share.install prefix/"man" unless OS.mac?
  end

  test do
    assert_match "Hello World!", shell_output("#{bin}/ngs -e 'echo(\"Hello World!\")'")
  end
end
