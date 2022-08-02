class Helmsman < Formula
  desc "Helm Charts as Code tool"
  homepage "https://github.com/Praqma/helmsman"
  url "https://github.com/Praqma/helmsman.git",
      tag:      "v3.13.0",
      revision: "a849965375d2115ded3d8653f42c29f1621e1dce"
  license "MIT"
  head "https://github.com/Praqma/helmsman.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/helmsman"
    sha256 cellar: :any_skip_relocation, mojave: "96013ae93b489627795dd09270e42dc04e7976076756f58a4f72e534bc908c23"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/helmsman"
    pkgshare.install "examples/example.yaml"
    pkgshare.install "examples/job.yaml"
  end

  test do
    ENV["ORG_PATH"] = "brewtest"
    ENV["VALUE"] = "brewtest"

    output = shell_output("#{bin}/helmsman --apply -f #{pkgshare}/example.yaml 2>&1", 1)
    assert_match "helm diff not found", output

    assert_match version.to_s, shell_output("#{bin}/helmsman version")
  end
end
