class Delve < Formula
  desc "Debugger for the Go programming language"
  homepage "https://github.com/go-delve/delve"
  url "https://github.com/go-delve/delve/archive/v1.7.3.tar.gz"
  sha256 "961642eb4cd97e11093dda81273971a45e64abb2fe7db39165072c7145f4fcec"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/delve"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "211401660270552bf56231eb570489adc738131599e842680dbc5c4ccc34f549"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"dlv"), "./cmd/dlv"
  end

  test do
    assert_match(/^Version: #{version}$/, shell_output("#{bin}/dlv version"))
  end
end
