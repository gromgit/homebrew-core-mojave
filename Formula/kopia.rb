class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.10.4",
      revision: "3447f1865f0b0536653aa6e9c07896ce73c3e600"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kopia"
    sha256 cellar: :any_skip_relocation, mojave: "338a1c0745c054b25ab3f1398964a651b99b8c28636cc631c8736c85953c80b3"
  end

  depends_on "go" => :build

  def install
    # removed github.com/kopia/kopia/repo.BuildGitHubRepo to disable
    # update notifications
    ldflags = %W[
      -s -w
      -X github.com/kopia/kopia/repo.BuildInfo=#{Utils.git_head}
      -X github.com/kopia/kopia/repo.BuildVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"kopia", "--completion-script-bash")
    (bash_completion/"kopia").write output

    output = Utils.safe_popen_read(bin/"kopia", "--completion-script-zsh")
    (zsh_completion/"_kopia").write output

    output = Utils.safe_popen_read(bin/"kopia", "--help-man")
    (man1/"kopia.1").write output
  end

  test do
    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    output = shell_output("#{bin}/kopia --version").strip

    # verify version output, note we're unable to verify the git hash in tests
    assert_match(%r{#{version} build: .* from:}, output)

    system "#{bin}/kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_predicate testpath/"repo/kopia.repository.f", :exist?
    system "#{bin}/kopia", "snapshot", "create", testpath/"testdir"
    system "#{bin}/kopia", "snapshot", "list"
    system "#{bin}/kopia", "repository", "disconnect"
  end
end
