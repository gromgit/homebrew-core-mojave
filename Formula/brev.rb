class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.36.tar.gz"
  sha256 "f16d2bda76ae1fd5be6d26664b96302b5d4d22ca6581d46cf98d279226852834"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brev"
    sha256 cellar: :any_skip_relocation, mojave: "0210351edd8e83e3f0bb9b12120e1a6f5d08dea3c08117fd560a2ab39f9de28c"
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
