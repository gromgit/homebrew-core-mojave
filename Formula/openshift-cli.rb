class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  license "Apache-2.0"
  head "https://github.com/openshift/oc.git", branch: "master"

  stable do
    url "https://github.com/openshift/oc.git",
        tag:      "openshift-clients-4.11.0-202204020828",
        revision: "f1f09a392fd18029f681c06c3bd0c44420684efa"
  end

  livecheck do
    url :stable
    regex(/^openshift-clients[._-](\d+(?:\.\d+)+(?:[._-]p?\d+)?)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openshift-cli"
    sha256 cellar: :any_skip_relocation, mojave: "0a68d36d24338d05604665c7c9cab0a3d6469aa07f666a1d10ea10e45ba1f713"
  end

  depends_on "coreutils" => :build
  # Bump to 1.18 on the next release.
  depends_on "go@1.17" => :build
  depends_on "heimdal" => :build
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
