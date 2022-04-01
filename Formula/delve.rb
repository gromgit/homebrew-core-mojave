class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.8.2.tar.gz"
  sha256 "fbf6ea7e1ed0c92e543c7f5f2343928e185e11e4cba1c7c9d3bfc28d1c323900"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/delve"
    sha256 cellar: :any_skip_relocation, mojave: "eb35a5191a05807d10582f790713666fc03a728c63deba80f3b42ef2cfee9ae5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
