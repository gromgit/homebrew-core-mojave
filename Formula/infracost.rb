class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.8.tar.gz"
  sha256 "e431beab103d6e011f5b32b5e67d76580051986c539e0d8ce0b2ea1a4984e320"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/infracost"
    sha256 cellar: :any_skip_relocation, mojave: "14b26581cb0117096ba631987f9e1ee1a966ce6d5bc848c21c491cee75c45359"
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
