class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.33.0.tar.gz"
  sha256 "d8ab631475c9080339d1e96410ad84ea26377fa3d0662d3903f05030f929860d"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/forcecli"
    sha256 cellar: :any_skip_relocation, mojave: "d6f86f881c3a16507ad5f92b27fdfadc08dff9bb45a43b34a5e1b17da53d2558"
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
