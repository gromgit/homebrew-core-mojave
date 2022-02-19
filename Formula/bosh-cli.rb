class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.16.tar.gz"
  sha256 "f549ee3359dfe858538989304d0f071783dd682d6101f77c690c7bdb5cd363d0"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bosh-cli"
    sha256 cellar: :any_skip_relocation, mojave: "1ffec4bfc37b11758935c9caf17d3d7f3d13cc9b2460ed082def82b5ca11cfa4"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath/"jobs/brew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
