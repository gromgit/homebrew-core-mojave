class WrenCli < Formula
  desc "Simple REPL and CLI tool for running Wren scripts"
  homepage "https://github.com/wren-lang/wren-cli"
  url "https://github.com/wren-lang/wren-cli/archive/0.4.0.tar.gz"
  sha256 "fafdc5d6615114d40de3956cd3a255e8737dadf8bd758b48bac00db61563cb4c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wren-cli"
    sha256 cellar: :any_skip_relocation, mojave: "b4115cdd4d07bb36eded9c0dbe0f11ac18990dfffcd27087eb271ebdd324de25"
  end

  def install
    if OS.mac?
      system "make", "-C", "projects/make.mac"
    else
      system "make", "-C", "projects/make"
    end
    bin.install "bin/wren_cli"
    pkgshare.install "example"
  end

  test do
    cp pkgshare/"example/hello.wren", testpath
    assert_equal "Hello, world!\n", shell_output("#{bin}/wren_cli hello.wren")
  end
end
