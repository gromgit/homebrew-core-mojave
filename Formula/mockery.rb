class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.10.4.tar.gz"
  sha256 "f706c1d6be2d620846730eafb14ca6366440f527fb946d55a008392b48299e4a"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mockery"
    sha256 cellar: :any_skip_relocation, mojave: "81e42b7e1d1709737d3584fb1cc2656043f8807ae0665c0fe209914e4e8ed980"
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
