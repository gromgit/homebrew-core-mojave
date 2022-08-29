class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.9.1.tar.gz"
  sha256 "d8d119e74ae47799baa60c08faf2c2872fefce9264b36475ddac8e3a7efc6727"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/delve"
    sha256 cellar: :any_skip_relocation, mojave: "5ccd949bc43f53bc0969cc47df43ed50cccf363ee3dd150b63c8143210d678b8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
