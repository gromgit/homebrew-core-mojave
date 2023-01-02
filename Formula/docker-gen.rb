class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/nginx-proxy/docker-gen"
  url "https://github.com/nginx-proxy/docker-gen/archive/0.9.1.tar.gz"
  sha256 "6e91460f1b72940aa6cb5ac110696f335061791ecdca56d5b3e422b31152c1c5"
  license "MIT"
  head "https://github.com/nginx-proxy/docker-gen.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-gen"
    sha256 cellar: :any_skip_relocation, mojave: "05706b3b01679c9363217fc54ec43950e3cf056b4835990c1a15b01779f3bcc6"
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
