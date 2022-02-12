class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.8.1.tar.gz"
  sha256 "e5b2ec78add2a167e1fdc11e3e189dec1bbed2cd9b6e99b3d79c0630b4b83e37"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/delve"
    sha256 cellar: :any_skip_relocation, mojave: "0645b63771d177d2b210936993a3a7b088b58ccd53c411c6397e3ef7210bbaf5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
