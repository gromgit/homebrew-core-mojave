class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.9.0.tar.gz"
  sha256 "9f270363d872e4d302b67b3baa3baec4d1c7b892814fd6a50e5953a2b90d745e"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-gen"
    sha256 cellar: :any_skip_relocation, mojave: "94c4f50f7a5fce5f42e3a96cde63260e838780615808c45b3662a7a018753be3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/docker-gen"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
