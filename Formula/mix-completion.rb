class MixCompletion < Formula
  desc "Elixir Mix completion plus shortcuts/colors"
  homepage "https://github.com/davidhq/mix-power-completion"
  url "https://github.com/davidhq/mix-power-completion/archive/0.8.2.tar.gz"
  sha256 "0e3e94b199f847926f3668b4cebf1b132e63a44d438425dd5c45ac4a299f28f3"
  head "https://github.com/davidhq/mix-power-completion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mix-completion"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "b3752da67d9c50a5a2a9fcfe3256495d653c1a59f943be27061a03baac3973bc"
  end

  def install
    bash_completion.install "mix"
  end

  test do
    assert_match "-F _mix",
      shell_output("bash -c 'source #{bash_completion}/mix && complete -p mix'")
  end
end
