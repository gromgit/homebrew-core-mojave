class Aztfy < Formula
  desc "Bring your existing Azure resources under the management of Terraform"
  homepage "https://azure.github.io/aztfy"
  url "https://github.com/Azure/aztfy.git",
      tag:      "v0.7.0",
      revision: "071ef92a56ffb8b7a8ff208f00c58350d9925672"
  license "MPL-2.0"
  head "https://github.com/Azure/aztfy.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aztfy"
    sha256 cellar: :any_skip_relocation, mojave: "248092b3e8792f4278eb9f981e8333a5c06410c4da6ed0c5379e784a9ce9329e"
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
