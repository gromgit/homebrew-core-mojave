class Colima < Formula
  desc "Container runtimes on MacOS with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.3.3",
      revision: "ac876a5d9e4eda7d1d015896ebfbe1dd16b8c203"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/colima"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "62ad7ee5d16b77b650c7119f53bc88ed192593e5f0552f333711badc3c38ece0"
  end

  depends_on "go" => :build
  depends_on "lima"
  depends_on :macos

  def install
    project = "github.com/abiosoft/colima"
    ldflags = %W[
      -X #{project}/config.appVersion=#{version}
      -X #{project}/config.revision=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/colima"

    (bash_completion/"colima").write Utils.safe_popen_read(bin/"colima", "completion", "bash")
    (zsh_completion/"_colima").write Utils.safe_popen_read(bin/"colima", "completion", "zsh")
    (fish_completion/"colima.fish").write Utils.safe_popen_read(bin/"colima", "completion", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/colima version 2>&1")
    assert_match "colima is not running", shell_output("#{bin}/colima status 2>&1", 1)
  end
end
