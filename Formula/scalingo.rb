class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.24.0.tar.gz"
  sha256 "0bc043ecc6f8b536800d7cab2974addec2737d51a80c4cef020bc47f82a5f7f2"
  license "BSD-4-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scalingo"
    sha256 cellar: :any_skip_relocation, mojave: "adbeb5d530e85bb4f4918074cfee361a6cd97ac8da08df00bb936636b50ef97b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "scalingo/main.go"
  end

  test do
    expected = <<~END
      +-------------------+-------+
      | CONFIGURATION KEY | VALUE |
      +-------------------+-------+
      | region            |       |
      +-------------------+-------+
    END
    assert_equal expected, shell_output("#{bin}/scalingo config")
  end
end
