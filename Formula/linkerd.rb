class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.11.2",
      revision: "d7a3ddf4bf41babc32aef79fdc5c40ef2bfb9283"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/linkerd"
    sha256 cellar: :any_skip_relocation, mojave: "a3d315b107ddfd3a2b66a30d36cca6c53a03914d02a4aad33fdf980291be99fd"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    # Install bash completion
    output = Utils.safe_popen_read(bin/"linkerd", "completion", "bash")
    (bash_completion/"linkerd").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"linkerd", "completion", "zsh")
    (zsh_completion/"_linkerd").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"linkerd", "completion", "fish")
    (fish_completion/"linkerd.fish").write output
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end
