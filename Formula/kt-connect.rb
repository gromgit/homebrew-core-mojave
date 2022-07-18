class KtConnect < Formula
  desc "Toolkit for integrating with kubernetes dev environment more efficiently"
  homepage "https://alibaba.github.io/kt-connect"
  url "https://github.com/alibaba/kt-connect/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "c29d4d9a18defdd8485adfe3a75b2887b42544fedd404073844629666bb28c9f"
  license "GPL-3.0-or-later"
  head "https://github.com/alibaba/kt-connect.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kt-connect"
    sha256 cellar: :any_skip_relocation, mojave: "ad57f3ece149c062833306a9c82222d14146fbc01e217d2a2b571982ed1eba30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"ktctl"), "./cmd/ktctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "bash")
    (bash_completion/"ktctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "zsh")
    (zsh_completion/"_ktctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "fish")
    (fish_completion/"ktctl.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktctl --version")
    # Should error out as exchange require a service name
    assert_match "name of service to exchange is required", shell_output("#{bin}/ktctl exchange 2>&1")
  end
end
