class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/refs/tags/1.22.0.tar.gz"
  sha256 "f08236d73195e9107f1a2d4aaf0d01bd40e852e8f032bc5d42227677f65ee4ec"
  license "BSD-4-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scalingo"
    sha256 cellar: :any_skip_relocation, mojave: "922add5cd90acc94d90e1e1b79f876b366dc07bf4d15a3aa61822eac7442ec64"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    config_output = shell_output("#{bin}/scalingo config")
    assert_equal config_output, expected
  end
end
