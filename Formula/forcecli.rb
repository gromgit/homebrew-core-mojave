class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.32.0.tar.gz"
  sha256 "6ece64315c576eac8d5650fb1d8f1895b5810d268355d2c4b0e83fcea8bb9a5f"
  license "MIT"
  head "https://github.com/ForceCLI/force.git"

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
