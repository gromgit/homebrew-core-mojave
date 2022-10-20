class Gebug < Formula
  desc "Debug Dockerized Go applications better"
  homepage "https://github.com/moshebe/gebug"
  url "https://github.com/moshebe/gebug/archive/refs/tags/v1.0.3.tar.gz"
  sha256 "1fc4ca057db026b23e62d8db67107ebfe648b68d7ec656abd10b2bfd684f29a2"
  license "Apache-2.0"
  head "https://github.com/moshebe/gebug.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gebug"
    sha256 cellar: :any_skip_relocation, mojave: "758417b5571cca6e680b67f78e27e97b89479ffb53d0e8a077c0ede68b566156"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/moshebe/gebug/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gebug", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    (testpath/".gebug/docker-compose.yml").write("")
    (testpath/".gebug/Dockerfile").write("")

    assert_match "Failed to perform clean up", shell_output(bin/"gebug clean 2>&1", 1)
    assert_match version.to_s, shell_output(bin/"gebug version")
  end
end
