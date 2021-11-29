class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.35.13.tar.gz"
  sha256 "b17dd616d7fc62918d169bb1231aa3c1448cc86ea6d98db16c91063b86ae3fcd"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terragrunt"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cc16911f91f8a4d94f3ac055f029161d6a47b2d6b14d6cb23e4cafbd206e2905"
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
