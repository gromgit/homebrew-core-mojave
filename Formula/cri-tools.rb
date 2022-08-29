class CriTools < Formula
  desc "CLI and validation tools for Kubelet Container Runtime Interface (CRI)"
  homepage "https://github.com/kubernetes-sigs/cri-tools"
  url "https://github.com/kubernetes-sigs/cri-tools/archive/v1.25.0.tar.gz"
  sha256 "bd900fac00b3247fa601f7aca4e0e44825dfd67d399c2830cbc643b7d73dbe52"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cri-tools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cri-tools"
    sha256 cellar: :any_skip_relocation, mojave: "eb45b4db58267183690c0fb42b88c9b3101ee00eeaa6bf2792d49727f3043f22"
  end

  depends_on "go" => :build

  def install
    ENV["BINDIR"] = bin

    if build.head?
      system "make", "install"
    else
      system "make", "install", "VERSION=#{version}"
    end

    output = Utils.safe_popen_read("#{bin}/crictl", "completion", "bash")
    (bash_completion/"crictl").write output

    output = Utils.safe_popen_read("#{bin}/crictl", "completion", "zsh")
    (zsh_completion/"_crictl").write output

    output = Utils.safe_popen_read("#{bin}/crictl", "completion", "fish")
    (fish_completion/"crictl.fish").write output
  end

  test do
    crictl_output = shell_output(
      "#{bin}/crictl --runtime-endpoint unix:///var/run/nonexistent.sock --timeout 10ms info 2>&1", 1
    )
    assert_match "unable to determine runtime API version", crictl_output

    critest_output = shell_output("#{bin}/critest --ginkgo.dryRun 2>&1")
    assert_match "PASS", critest_output
  end
end
