class Argocd < Formula
  desc "GitOps Continuous Delivery for Kubernetes"
  homepage "https://argoproj.github.io/cd"
  url "https://github.com/argoproj/argo-cd.git",
      tag:      "v2.2.1",
      revision: "122ecefc3abfe8b691a08d9f3cecf9a170cc8c37"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/argocd"
    sha256 cellar: :any_skip_relocation, mojave: "a8a04ca93db7229077efbc3b3b664018a442e8b6282a723974990104fffbf26b"
  end

  depends_on "go" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build

  def install
    system "make", "dep-ui-local"
    with_env(
      NODE_ENV:        "production",
      NODE_ONLINE_ENV: "online",
    ) do
      system "yarn", "--cwd", "ui", "build"
    end
    system "make", "cli-local"
    bin.install "dist/argocd"

    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "bash")
    (bash_completion/"argocd").write output
    output = Utils.safe_popen_read("#{bin}/argocd", "completion", "zsh")
    (zsh_completion/"_argocd").write output
  end

  test do
    assert_match "argocd controls a Argo CD server",
      shell_output("#{bin}/argocd --help")

    # Providing argocd with an empty config file returns the contexts table header
    touch testpath/"argocd-config"
    assert_match "CURRENT  NAME  SERVER\n",
      shell_output("#{bin}/argocd context --config ./argocd-config")
  end
end
