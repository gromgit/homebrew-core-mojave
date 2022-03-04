class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.19.tar.gz"
  sha256 "ff6fd0afa4debad5cac190519a5cef250246df8cddfb84dc2d5bc40c2624d36d"
  license "MIT"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brev"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4a0842052c5a2cf42e3b943ec888aae7596e477ed237a13bb93a552b28e07e5f"
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
