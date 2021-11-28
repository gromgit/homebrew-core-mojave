class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/1.4.0.tar.gz"
  sha256 "c066dda527fd0717ec3188bb1576b4013ab1b23141df15fd58d4650b6c575089"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kumactl"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8eac24557d541ab3dfd5fa864cca5dd8f57e273c38a21cce8b6a1990d4251698"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags), "./app/kumactl"

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "bash")
    (bash_completion/"kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "zsh")
    (zsh_completion/"_kumactl").write output

    output = Utils.safe_popen_read("#{bin}/kumactl", "completion", "fish")
    (fish_completion/"kumactl.fish").write output
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
