class Colima < Formula
  desc "Container runtimes on MacOS (and Linux) with minimal setup"
  homepage "https://github.com/abiosoft/colima/blob/main/README.md"
  url "https://github.com/abiosoft/colima.git",
      tag:      "v0.4.2",
      revision: "f112f336d05926d62eb6134ee3d00f206560493b"
  license "MIT"
  head "https://github.com/abiosoft/colima.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/colima"
    sha256 cellar: :any_skip_relocation, mojave: "e8ee22c59f892261f492fa16dc7c87b28175d7e41e0263da015db37f9af5577f"
  end

  depends_on "go" => :build
  depends_on "lima"

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
