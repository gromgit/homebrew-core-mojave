class Zbctl < Formula
  desc "Zeebe CLI client"
  homepage "https://docs.camunda.io/docs/apis-clients/cli-client/index/"
  url "https://github.com/camunda/zeebe.git",
      tag:      "8.0.0",
      revision: "74e2dae4e112d0ecd600d1b55cbc588609b792a7"
  license "Apache-2.0"
  head "https://github.com/camunda/zeebe.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zbctl"
    sha256 cellar: :any_skip_relocation, mojave: "18849ceca39cecdfb2c46e2d1c4785ef99e06d8472fdc7bbd49389ff557bb0fb"
  end

  depends_on "go" => :build

  def install
    commit = Utils.git_short_head
    chdir "clients/go/cmd/zbctl" do
      project = "github.com/camunda/zeebe/clients/go/cmd/zbctl/internal/commands"
      ldflags = %W[
        -w
        -X #{project}.Version=#{version}
        -X #{project}.Commit=#{commit}
      ]
      system "go", "build", "-tags", "netgo", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    # Check status for a nonexistent cluster
    status_error_message =
      "Error: rpc error: code =" \
      " Unavailable desc = connection error:" \
      " desc = \"transport: Error while dialing dial tcp 127.0.0.1:26500: connect: connection refused\""
    output = shell_output("#{bin}/zbctl status 2>&1", 1)
    assert_match status_error_message, output
    # Check version
    commit = stable.specs[:revision][0..7]
    expected_version = "zbctl #{version} (commit: #{commit})"
    assert_match expected_version, shell_output("#{bin}/zbctl version")
  end
end
