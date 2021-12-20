class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.15.tar.gz"
  sha256 "1a0239c140e762987687f1e52fef929e434d15566f18008ca3251876a9f9cc03"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/infracost"
    sha256 cellar: :any_skip_relocation, mojave: "678bddd844510552180b922e145d8b8f6b3030ab2dc4bee43281424c727e08e7"
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
