class GemCompletion < Formula
  desc "Bash completion for gem"
  homepage "https://github.com/mernen/completion-ruby"
  url "https://github.com/mernen/completion-ruby.git",
      revision: "f3e4345042b0cc48317e45b673dfd3d23904b9a7"
  version "2"
  license "MIT"
  head "https://github.com/mernen/completion-ruby.git", branch: "master"

  livecheck do
    formula "ruby-completion"
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gem-completion"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0a01abb125cae8707c0684b207d5c3a08effd29a11048bdca549e245e60ea76c"
  end

  def install
    bash_completion.install "completion-gem" => "gem"
  end

  test do
    assert_match "-F __gem",
      shell_output("bash -c 'source #{bash_completion}/gem && complete -p gem'")
  end
end
