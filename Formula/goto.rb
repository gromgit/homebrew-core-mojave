class Goto < Formula
  desc "Bash tool for navigation to aliased directories with auto-completion"
  homepage "https://github.com/iridakos/goto"
  url "https://github.com/iridakos/goto/archive/v2.0.0.tar.gz"
  sha256 "460fe3994455501b50b2f771f999ace77ade295122e90e959084047dbfb1f0dc"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goto"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "2987f6fbf9e2e5a2c551ab3cc25d9ce643fefbcbb9967b2b18cf65b6f2682f93"
  end

  def install
    bash_completion.install "goto.sh"
  end

  test do
    assert_match "-F _complete_goto_bash",
      shell_output("bash -c 'source #{bash_completion}/goto.sh && complete -p goto'")
  end
end
