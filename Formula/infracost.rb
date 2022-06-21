class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.3.tar.gz"
  sha256 "88d1562b0dd0c228ffe23f009959fa7fe157db46d166e6769473d8f40cca0b39"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/infracost"
    sha256 cellar: :any_skip_relocation, mojave: "a6fa3080b8c126cc6e39d467f12e33f7f4624d9315d4965409d2db5c15f0cea0"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
