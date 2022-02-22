class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.19.tar.gz"
  sha256 "ff6fd0afa4debad5cac190519a5cef250246df8cddfb84dc2d5bc40c2624d36d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/brev"
    sha256 cellar: :any_skip_relocation, mojave: "33b68cf244648d614d239e57362fe195ee0d9457a2d3ac888c99a60a7c7e3aa3"
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
