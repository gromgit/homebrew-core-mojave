class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.10.0.tar.gz"
  sha256 "a3dcfa1f0599858bbc3ac1cdb17a09702ce0236fd329ddad80f975b8ee11efd1"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mockery"
    sha256 cellar: :any_skip_relocation, mojave: "9bee2a052c9191db9a3d2f15012e2e30225f6e9d3db113971972cb6619fbc36f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/vektra/mockery/v2/pkg/config.SemVer=v#{version}")
  end

  test do
    output = shell_output("#{bin}/mockery --keeptree 2>&1", 1)
    assert_match "Starting mockery dry-run=false version=v#{version}", output

    output = shell_output("#{bin}/mockery --all --dry-run 2>&1")
    assert_match "INF Walking dry-run=true version=v#{version}", output
  end
end
