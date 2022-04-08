class Velero < Formula
  desc "Disaster recovery for Kubernetes resources and persistent volumes"
  homepage "https://github.com/vmware-tanzu/velero"
  url "https://github.com/vmware-tanzu/velero/archive/v1.8.1.tar.gz"
  sha256 "675034d30d3539f9292ca5896e28df6159cdf1c6436d806795a79c61bfe37cd7"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/velero"
    sha256 cellar: :any_skip_relocation, mojave: "a1a6f8d6e54133a87174182d3075c9196f73b844cbc9059338fec7bdc319fc97"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/vmware-tanzu/velero/pkg/buildinfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-installsuffix", "static", "./cmd/velero"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"velero", "completion", "bash")
    (bash_completion/"velero").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"velero", "completion", "zsh")
    (zsh_completion/"_velero").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"velero", "completion", "fish")
    (fish_completion/"velero.fish").write output
  end

  test do
    output = shell_output("#{bin}/velero 2>&1")
    assert_match "Velero is a tool for managing disaster recovery", output
    assert_match "Version: v#{version}", shell_output("#{bin}/velero version --client-only 2>&1")
    system bin/"velero", "client", "config", "set", "TEST=value"
    assert_match "value", shell_output("#{bin}/velero client config get 2>&1")
  end
end
