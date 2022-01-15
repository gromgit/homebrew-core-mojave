class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.6.0",
      revision: "5316d4acc957286b43fe29e64684af694de6841d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitlab-runner"
    sha256 cellar: :any_skip_relocation, mojave: "a229ce1de67923569e798bb945710f9d2d0760001625e963d11388196f87095c"
  end

  depends_on "go" => :build

  # Remove patch for Go FD=0 bug (CVE-2021-44717), as go is already patched against this CVE.
  # Remove during v14.7.0 update.
  patch do
    url "https://gitlab.com/gitlab-org/gitlab-runner/-/commit/99f7b8063024357389f07f1e977d280ec35195e1.diff"
    sha256 "115eb6f9c02eaa05fea945d76a42ef5585cac7c5ee9938cab0183330401506a6"
  end

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
