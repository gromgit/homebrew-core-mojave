class Mockery < Formula
  desc "Mock code autogenerator for Golang"
  homepage "https://github.com/vektra/mockery"
  url "https://github.com/vektra/mockery/archive/v2.12.3.tar.gz"
  sha256 "78991251b8b6e1ca1d70c3604040802c007737284580fb2e35612624804028f5"
  license "BSD-3-Clause"
  head "https://github.com/vektra/mockery.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mockery"
    sha256 cellar: :any_skip_relocation, mojave: "2b52f88d611d33378c585e07df91b06ad09c3053fc6a234f7070303fd8f43527"
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
