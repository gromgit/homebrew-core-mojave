class DockerSwarm < Formula
  desc "Turn a pool of Docker hosts into a single, virtual host"
  homepage "https://github.com/docker/classicswarm"
  url "https://github.com/docker/classicswarm/archive/v1.2.9.tar.gz"
  sha256 "13d0d39dbd2bccb32016e6aa782da67b6207f203e253e06b0f6eb4f25da85474"
  license "Apache-2.0"
  head "https://github.com/docker/classicswarm.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-swarm"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "1c8c6ea4c3e92429921c7198e500492a9febf7db9e7adc8e999358238a0ca11c"
  end


  # "Classic Swarm has been archived and is no longer actively developed. You
  # may want to use the Swarm mode built into the Docker Engine instead, or
  # another orchestration system."
  deprecate! date: "2020-06-11", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/docker/swarm").install buildpath.children
    cd "src/github.com/docker/swarm" do
      system "go", "build", "-o", bin/"docker-swarm"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-swarm --version")
  end
end
