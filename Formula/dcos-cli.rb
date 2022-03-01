class DcosCli < Formula
  desc "Command-line interface for managing DC/OS clusters"
  homepage "https://docs.d2iq.com/mesosphere/dcos/latest/cli"
  url "https://github.com/dcos/dcos-cli/archive/1.2.0.tar.gz"
  sha256 "d75c4aae6571a7d3f5a2dad0331fe3adab05a79e2966c0715409d6a2be2c6105"
  license "Apache-2.0"
  head "https://github.com/dcos/dcos-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dcos-cli"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "19c930efdcfb04b4c18ce2a8418eed5f652c755da3f943434f3a120ad8bd52dc"
  end


  depends_on "go" => :build

  def install
    ENV["NO_DOCKER"] = "1"
    ENV["VERSION"] = version.to_s
    kernel_name = OS.kernel_name.downcase

    system "make", kernel_name
    bin.install "build/#{kernel_name}/dcos"
  end

  test do
    run_output = shell_output("#{bin}/dcos --version 2>&1")
    assert_match "dcoscli.version=#{version}", run_output
  end
end
