class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.2.tar.gz"
  sha256 "4a616727869840344eda89d87df6ff09d31f38133eddaf051d481299bef7e63a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-gen"
    sha256 cellar: :any_skip_relocation, mojave: "3d84d1987259903c3c496e8a3eeea285343d0dcd855257db112220d31878f469"
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
