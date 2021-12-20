class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.1.tar.gz"
  sha256 "c326e4af103ed2bf0da518f0d14f7207cfc73761955a3a6e121dd7e540ccd4d9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-gen"
    sha256 cellar: :any_skip_relocation, mojave: "32163225064dfd4b7803ab823be2971097c6548103caca5cf4ec6a5321488b61"
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
