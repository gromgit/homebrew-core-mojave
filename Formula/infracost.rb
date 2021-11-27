class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.13.tar.gz"
  sha256 "27c21b3aebc6a95af398addfb6f92706863acbbdfeda35d751aced7ded465544"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/infracost"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "69d0bfed4809baed5a7784eaf5c026bf53d9a6aa4887c976fb7f8b841c8f0dbc"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
