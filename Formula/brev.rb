class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.17.tar.gz"
  sha256 "cf69be0558cd87ca5838372aeca6b85fe937f1bd8eb44c03a88355ca088aa9ea"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brev"
    sha256 cellar: :any_skip_relocation, mojave: "5e5f78fc089b3aa30a644b9bc1ccd31b2feff6fbe61b7d47f93b88132299b12f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
