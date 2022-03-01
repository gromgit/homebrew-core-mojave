class DockerComposeCompletion < Formula
  desc "Completion script for docker-compose"
  homepage "https://docs.docker.com/compose/completion/"
  url "https://github.com/docker/compose/archive/1.29.2.tar.gz"
  sha256 "99a9b91d476062d280c889ae4e9993d7dd6a186327bafb2bb39521f9351b96eb"
  license "Apache-2.0"
  head "https://github.com/docker/compose.git", branch: "v2"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-compose-completion"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c597fd578d8931e28e1269735ced22f28c92fe2d77be6fcf93ac032f6660104b"
  end


  # See: https://github.com/docker/compose/issues/8550
  deprecate! date: "2021-10-02", because: "no upstream support for v2"

  def install
    bash_completion.install "contrib/completion/bash/docker-compose"
    fish_completion.install "contrib/completion/fish/docker-compose.fish"
    zsh_completion.install "contrib/completion/zsh/_docker-compose"
  end

  test do
    assert_match "-F _docker_compose",
      shell_output("bash -c 'source #{bash_completion}/docker-compose && complete -p docker-compose'")
  end
end
