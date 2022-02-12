class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.36.0",
      revision: "189a55291c18ac850277134d2b8f3eaa2c4f7a1d"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/skaffold"
    sha256 cellar: :any_skip_relocation, mojave: "53bd2cbbf8424f622db3459eee6a77e0a9748973bc89638a3629618205639d2b"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end
