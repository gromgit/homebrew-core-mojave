class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "f4ed993012d2315080a758e683ebe5f36eff6f389b2e68b2857f380bf1049228"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liqoctl"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "3725f4f6f2347f0d128cfe46c6642b74a5aba8fa7db2ebe33bea68692238593b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    generate_completions_from_executable(bin/"liqoctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version --client")
  end
end
