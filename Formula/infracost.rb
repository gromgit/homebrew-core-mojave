class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.15.tar.gz"
  sha256 "566be4b7fc228d07a842c11797a5976d4699226ece752b0ff5f9867c2e0e4301"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/infracost"
    sha256 cellar: :any_skip_relocation, mojave: "e5192abd8bb31618295d3d0b8e478f55de1883f923f8bd6865cf0836dd65f91f"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
