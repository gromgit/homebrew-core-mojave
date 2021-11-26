class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.8.0.tar.gz"
  sha256 "3d969c32d1a612d44c8193422649b375ea9cea8d78a044be463d58fe128c525a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/docker-gen"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "244afe96498034c78cfdc3ee3cbd7e653e223819acbe3bd33fc1029546c1059c"
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
