class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "54c194a3877074b3e9790d086abaa3d7004ace5970f856947098dcc65948fdb3"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/epinio"
    sha256 cellar: :any_skip_relocation, mojave: "fa269ed8676fc36960448c6fe11c60e78f3dd46d9963338a03f2977a2368da59"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
