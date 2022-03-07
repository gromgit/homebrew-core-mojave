class KitchenCompletion < Formula
  desc "Bash completion for Kitchen"
  homepage "https://github.com/MarkBorcherding/test-kitchen-bash-completion"
  url "https://github.com/MarkBorcherding/test-kitchen-bash-completion/archive/v1.0.0.tar.gz"
  sha256 "6a9789359dab220df0afad25385dd3959012cfa6433c8c96e4970010b8cfc483"
  license "MIT"
  head "https://github.com/MarkBorcherding/test-kitchen-bash-completion.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kitchen-completion"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8c0958a87522fe9fa2159f1074d2a09d44395dfcd0af8559d96cd572620ddeee"
  end

  def install
    bash_completion.install "kitchen-completion.bash" => "kitchen"
  end

  test do
    assert_match "-F __kitchen_options",
      shell_output("bash -c 'source #{bash_completion}/kitchen && complete -p kitchen'")
  end
end
