class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.20.tar.gz"
  sha256 "eeb81d773b8fc32a61a13738a146d1464ca82584b536cd73cc7db6edc5e08ca4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terragrunt"
    sha256 cellar: :any_skip_relocation, mojave: "838ed9426aab34bf7baf583e0c512b2983562d8002395c6cc119f5d354f5ecf7"
  end

  depends_on "go" => :build
  depends_on "terraform"

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
