class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.4.tar.gz"
  sha256 "5aa3f69f365a1f2120e70bd74cb29153a5a148181856d832f06179052e0d8646"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-gen"
    sha256 cellar: :any_skip_relocation, mojave: "ed23e3f3e6ed00fff393e4950fd28adf5c437bb6edc44a02b2a01e5247d1e4cf"
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
