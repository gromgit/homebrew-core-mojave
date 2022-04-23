class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.7",
      revision: "18c19174a2a892ff3157a4a3a8bb06ab6dcb50fe"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dagger"
    sha256 cellar: :any_skip_relocation, mojave: "a258cfd3619e3ac4c9090896d35d3e085596d8098a3602ca0b5bc825307c3794"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X go.dagger.io/dagger/version.Revision=#{Utils.git_head(length: 8)}
      -X go.dagger.io/dagger/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    output = Utils.safe_popen_read(bin/"dagger", "completion", "bash")
    (bash_completion/"dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "zsh")
    (zsh_completion/"_dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "fish")
    (fish_completion/"dagger.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/dagger version")

    system bin/"dagger", "project", "init", "--template=hello"
    system bin/"dagger", "project", "update"
    assert_predicate testpath/"cue.mod/module.cue", :exist?

    output = shell_output("#{bin}/dagger do hello 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
