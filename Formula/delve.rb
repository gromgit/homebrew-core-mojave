class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.9.0.tar.gz"
  sha256 "daec5909ce6e44b7b2c49eea90b4aa964d2ff96c1e875b09891a26546f9ae871"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/delve"
    sha256 cellar: :any_skip_relocation, mojave: "46854559f4c60dadf6bc985d11128e32bd852b3e252bb1b3d4c627d76209c393"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
