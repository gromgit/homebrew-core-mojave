class MavenCompletion < Formula
  desc "Bash completion for Maven"
  homepage "https://github.com/juven/maven-bash-completion"
  url "https://github.com/juven/maven-bash-completion/archive/20200420.tar.gz"
  sha256 "eb4ef412d140e19e7d3ce23adb7f8fcce566f44388cfdc8c1e766a3c4b183d3d"
  license "Apache-2.0"
  head "https://github.com/juven/maven-bash-completion.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/maven-completion"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c911bebd7fd863a706752f963542bd5947416c88a9294c3e2ca361d09ca35690"
  end

  def install
    bash_completion.install "bash_completion.bash" => "maven"
  end

  test do
    assert_match "-F _mvn",
      shell_output("bash -c 'source #{bash_completion}/maven && complete -p mvn'")
  end
end
