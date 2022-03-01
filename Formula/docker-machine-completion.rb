class DockerMachineCompletion < Formula
  desc "Completion script for docker-machine"
  homepage "https://docs.docker.com/machine/completion/"
  url "https://github.com/docker/machine/archive/v0.16.2.tar.gz"
  sha256 "af8bff768cd1746c787e2f118a3a8af45ed11679404b6e45d5199e343e550059"
  license "Apache-2.0"
  head "https://github.com/docker/machine.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-machine-completion"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4a2957964ec5ed559c6ad72523c23cb7b5804f1c96fb77c404e6b38f376656a8"
  end


  deprecate! date: "2021-09-30", because: :repo_archived

  conflicts_with "docker-machine",
    because: "docker-machine already includes completion scripts"

  def install
    bash_completion.install Dir["contrib/completion/bash/*.bash"]
    zsh_completion.install "contrib/completion/zsh/_docker-machine"
  end

  test do
    assert_match "-F _docker_machine",
      shell_output("bash -O extglob -c 'source #{bash_completion}/docker-machine.bash && complete -p docker-machine'")
  end
end
