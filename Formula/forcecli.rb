class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.32.0.tar.gz"
  sha256 "6ece64315c576eac8d5650fb1d8f1895b5810d268355d2c4b0e83fcea8bb9a5f"
  license "MIT"
  head "https://github.com/ForceCLI/force.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/forcecli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "efca2983d77717495ede17896c8d1346c487ea1ab089ce8a4e1d56d3083f6ff0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
