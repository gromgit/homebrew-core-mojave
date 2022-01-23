class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.22.1.tar.gz"
  sha256 "cef2766e41a21eadf8b6a00e467bfb2c9234373d5cc52a272100cefed99a2380"
  license "BSD-4-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scalingo"
    sha256 cellar: :any_skip_relocation, mojave: "a54fa60fddc0b07cd2f8bbe9b4ccd26de70af05051516758a656e771b8fcd9d8"
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
