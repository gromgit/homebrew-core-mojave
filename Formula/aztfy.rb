class Aztfy < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfy"
  url "https://github.com/Azure/aztfy.git",
      tag:      "v0.6.0",
      revision: "18b614bb384b1d413554867b8601feb753715575"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfy.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aztfy"
    sha256 cellar: :any_skip_relocation, mojave: "0c1fbbb4c588cb9e035adada127e107b56f13381a9c34bdefcf212e6c858f3bc"
  end
  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'main.version=v#{version}' -X 'main.revision=#{Utils.git_short_head(length: 7)}'")
  end

  test do
    version_output = shell_output("#{bin}/aztfy -v")
    assert_match version.to_s, version_output

    no_resource_group_specified_output = shell_output("#{bin}/aztfy rg 2>&1", 1)
    assert_match("Error: No resource group specified", no_resource_group_specified_output)
  end
end
