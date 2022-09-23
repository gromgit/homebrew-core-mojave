class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.25.0.tar.gz"
  sha256 "6c3a9b45fdda66d548a12a37c9978477bd927fd53e6f7f08d11159a480c8ea77"
  license "BSD-4-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scalingo"
    sha256 cellar: :any_skip_relocation, mojave: "e88710925a00b34d6a07a4dc299f3d4d6c084a98d22e5e3efb526f88699ec6ed"
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
