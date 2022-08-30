class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", branch: "master"

  stable do
    url "https://github.com/openshift/oc.git",
        tag:      "openshift-clients-4.12.0-202208031327",
        revision: "3c85519af6c4979c02ebb1886f45b366bbccbf55"
  end

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+(?:[._-]p?\d+)?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openshift-cli"
    sha256 cellar: :any_skip_relocation, mojave: "fa0c614ef0bdd2643a20ee90a1e31e2c765e1c6fa59a5413b245d5f8872e10d7"
  end

  depends_on "coreutils" => :build
  depends_on "go@1.18" => :build
  depends_on "socat"

  uses_from_macos "krb5"

  def install
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase

    # See https://github.com/golang/go/issues/26487
    ENV.O0 if OS.linux?

    args = ["cross-build-#{os}-#{arch}"]
    args << if build.stable?
      "WHAT=cmd/oc"
    else
      "WHAT=staging/src/github.com/openshift/oc/cmd/oc"
    end
    args << "SHELL=/bin/bash" if OS.linux?

    system "make", *args
    bin.install "_output/bin/#{os}_#{arch}/oc"

    bash_completion.install "contrib/completions/bash/oc"
    zsh_completion.install "contrib/completions/zsh/oc" => "_oc"
  end

  test do
    (testpath/"kubeconfig").write ""
    system "KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config set-context foo 2>&1"
    context_output = shell_output("KUBECONFIG=#{testpath}/kubeconfig #{bin}/oc config get-contexts -o name")

    assert_match "foo", context_output
  end
end
