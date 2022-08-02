class DockerMachine < Formula
  desc "Create Docker hosts locally and on cloud providers"
  homepage "https://docs.docker.com/machine"
  url "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git",
      tag:      "v0.16.2-gitlab.18",
      revision: "cd8285a7e2310276c7d20575f15bba40a0678ed9"
  version "0.16.2-gitlab.18"
  license "Apache-2.0"
  head "https://gitlab.com/gitlab-org/ci-cd/docker-machine.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-machine"
    sha256 cellar: :any_skip_relocation, mojave: "72071fdc08b7407421883033910204324e4ba516034899bfefd36c07470805f7"
  end

  # Commented out while this formula still has dependents.
  # deprecate! date: "2021-09-30", because: :repo_archived

  depends_on "automake" => :build
  depends_on "go" => :build

  conflicts_with "docker-machine-completion", because: "docker-machine already includes completion scripts"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker/machine").install buildpath.children
    cd "src/github.com/docker/machine" do
      system "make", "build"
      bin.install Dir["bin/*"]
      bash_completion.install Dir["contrib/completion/bash/*.bash"]
      zsh_completion.install "contrib/completion/zsh/_docker-machine"
      prefix.install_metafiles
    end
  end

  plist_options manual: "docker-machine start"
  service do
    run [opt_bin/"docker-machine", "start", "default"]
    environment_variables PATH: std_service_path_env
    run_type :immediate
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output(bin/"docker-machine --version")
  end
end
