class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.14.tar.gz"
  sha256 "1c4e62fc70b70be5c5592a2b41c0d869a34b1f4a540ff101d9b6349bba399af4"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/infracost"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "a70f6039588b6d0b686d0c4fecb0ef309f5a6ba07062fab6110fd1b296c4f93c"
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
