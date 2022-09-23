class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.38.12.tar.gz"
  sha256 "4b467c7eecbf81d4606374e51b3fbe11c8d4f1303a252d527974caba8833c603"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/terragrunt"
    sha256 cellar: :any_skip_relocation, mojave: "bb7d385cc4b2985546946b098ff38961343f12dcf09b4086f5decd74f5e3c9a2"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
