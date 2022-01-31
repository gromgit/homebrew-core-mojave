class OdoDev < Formula
  desc "Developer-focused CLI for Kubernetes and OpenShift"
  homepage "https://odo.dev"
  url "https://github.com/redhat-developer/odo.git",
      tag:      "v2.5.0",
      revision: "724f16e689545dd4a81671da3e116a33df4832d3"
  license "Apache-2.0"
  head "https://github.com/redhat-developer/odo.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/odo-dev"
    sha256 cellar: :any_skip_relocation, mojave: "6e4fbf385ba5cb07502df87e72f0e187ab0b22e41702a98d4818561215dac0ba"
  end

  depends_on "go" => :build
  conflicts_with "odo", because: "odo also ships 'odo' binary"

  def install
    system "make", "bin"
    bin.install "odo"
  end

  test do
    # try set preference
    ENV["GLOBALODOCONFIG"] = "#{testpath}/preference.yaml"
    system bin/"odo", "preference", "set", "ConsentTelemetry", "false"
    assert_predicate testpath/"preference.yaml", :exist?

    # test version
    version_output = shell_output("#{bin}/odo version --client 2>&1").strip
    assert_match(/odo v#{version} \([a-f0-9]{9}\)/, version_output)

    # try to creation new component
    system bin/"odo", "create", "nodejs"
    assert_predicate testpath/"devfile.yaml", :exist?

    push_output = shell_output("#{bin}/odo push 2>&1", 1).strip
    assert_match("invalid configuration", push_output)
  end
end
