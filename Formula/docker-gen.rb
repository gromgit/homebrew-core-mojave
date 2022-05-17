class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.9.0.tar.gz"
  sha256 "9f270363d872e4d302b67b3baa3baec4d1c7b892814fd6a50e5953a2b90d745e"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-gen"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6ac4e4584868ef728784076e042c9bdfa1f2f7b1334526c77982e55a7a4b0e2d"
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
