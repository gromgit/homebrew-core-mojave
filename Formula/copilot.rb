require "language/node"

class Copilot < Formula
  desc "CLI tool for Amazon ECS and AWS Fargate"
  homepage "https://aws.github.io/copilot-cli/"
  url "https://github.com/aws/copilot-cli.git",
      tag:      "v1.19.0",
      revision: "33ee39e861e148867b7ecb62f6dc46d50ac5c5e4"
  license "Apache-2.0"
  head "https://github.com/aws/copilot-cli.git", branch: "mainline"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/copilot"
    sha256 cellar: :any_skip_relocation, mojave: "49cb81507c1d8130738f65acbe2ff192fc04fedf0d06b0c59aa6ccc95e6e327b"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    Language::Node.setup_npm_environment

    system "make", "tools"
    system "make", "package-custom-resources"
    system "make", "build"

    bin.install "bin/local/copilot"

    output = Utils.safe_popen_read(bin/"copilot", "completion", "bash")
    (bash_completion/"copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "zsh")
    (zsh_completion/"_copilot").write output

    output = Utils.safe_popen_read(bin/"copilot", "completion", "fish")
    (fish_completion/"copilot.fish").write output
  end

  test do
    begin
      _, stdout, wait_thr = Open3.popen2("AWS_REGION=eu-west-1 #{bin}/copilot init 2>&1")
      assert_match "Note: It's best to run this command in the root of your Git repository.", stdout.gets("\n")
    ensure
      Process.kill 9, wait_thr.pid
    end

    assert_match "could not find an application attached to this workspace, please run `app init` first",
      shell_output("AWS_REGION=eu-west-1 #{bin}/copilot pipeline init 2>&1", 1)
  end
end
