class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.33.0.tar.gz"
  sha256 "d8ab631475c9080339d1e96410ad84ea26377fa3d0662d3903f05030f929860d"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/forcecli"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "de0882f3d737f6fcd0b1320847dc682ce69e4395e52b5ed8f93bac270073f9fa"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"force"
  end

  test do
    assert_match "Usage: force <command> [<args>]",
                 shell_output("#{bin}/force help")
  end
end
