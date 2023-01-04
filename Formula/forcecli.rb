class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.99.4.tar.gz"
  sha256 "8439143f865b9baf8b5d073be5ff68d67e11873dc5edf50541525c14dd28a543"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/forcecli"
    sha256 cellar: :any_skip_relocation, mojave: "c48dfd95a424af462ca8add88e039178c62dc98780d94192ca69c85e40778822"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
