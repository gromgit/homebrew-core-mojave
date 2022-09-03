class Scalingo < Formula
  desc "CLI for working with Scalingo's PaaS"
  homepage "https://doc.scalingo.com/cli"
  url "https://github.com/Scalingo/cli/archive/1.24.2.tar.gz"
  sha256 "b6ef956fba4c0887b257568bd742a7098f5d98ad62e64e44330c641dd94f7e51"
  license "BSD-4-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scalingo"
    sha256 cellar: :any_skip_relocation, mojave: "fb469b41215f4a995cfe752de860471731cc5e22afcbb6c082f17841f417b42a"
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
