class Kubecfg < Formula
  desc "Manage complex enterprise Kubernetes environments as code"
  homepage "https://github.com/kubecfg/kubecfg"
  url "https://github.com/kubecfg/kubecfg/archive/v0.25.0.tar.gz"
  sha256 "884708337842341d4f777e00321bfa72b16bf73027a583305ebb281000096714"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubecfg"
    sha256 cellar: :any_skip_relocation, mojave: "0707873a9d955d7d3b9f2ec4098deb3553da2825d3299ced562c6a0717ba81e2"
  end

  depends_on "go" => :build

  def install
    (buildpath/"src/github.com/kubecfg/kubecfg").install buildpath.children

    cd "src/github.com/kubecfg/kubecfg" do
      system "make", "VERSION=v#{version}"
      bin.install "kubecfg"
      pkgshare.install Dir["examples/*"], "testdata/kubecfg_test.jsonnet"
      prefix.install_metafiles
    end

    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "bash")
    (bash_completion/"kubecfg").write output
    output = Utils.safe_popen_read("#{bin}/kubecfg", "completion", "--shell", "zsh")
    (zsh_completion/"_kubecfg").write output
  end

  test do
    system bin/"kubecfg", "show", pkgshare/"kubecfg_test.jsonnet"
  end
end
