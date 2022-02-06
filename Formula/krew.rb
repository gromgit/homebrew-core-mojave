class Krew < Formula
  desc "Package manager for kubectl plugins"
  homepage "https://sigs.k8s.io/krew/"
  url "https://github.com/kubernetes-sigs/krew.git",
      tag:      "v0.4.3",
      revision: "dbfefa58e3087bdd8eb1985a28f7caa7427c4e4d"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/krew.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/krew"
    sha256 cellar: :any_skip_relocation, mojave: "e0d11cd3262ae8f3ca681d90f9af581fd497f82a3564d1757f10e0cdf9f7a6d3"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    # build in local dir to avoid this error:
    # go build: cannot write multiple packages to non-directory /usr/local/Cellar/krew/0.3.2/bin/krew
    mkdir "build"

    ldflags = %W[
      -w
      -X sigs.k8s.io/krew/internal/version.gitCommit=#{Utils.git_short_head(length: 8)}
      -X sigs.k8s.io/krew/internal/version.gitTag=v#{version}
    ]

    system "go", "build", "-o", "build", "-tags", "netgo",
      "-ldflags", ldflags.join(" "), "./cmd/krew"
    # install as kubectl-krew for kubectl to find as plugin
    bin.install "build/krew" => "kubectl-krew"
  end

  test do
    ENV["KREW_ROOT"] = testpath
    ENV["PATH"] = "#{ENV["PATH"]}:#{testpath}/bin"
    system "#{bin}/kubectl-krew", "version"
    system "#{bin}/kubectl-krew", "update"
    system "#{bin}/kubectl-krew", "install", "ctx"
    assert_match "v#{version}", shell_output("#{bin}/kubectl-krew version")
    assert_predicate testpath/"bin/kubectl-ctx", :exist?
  end
end
