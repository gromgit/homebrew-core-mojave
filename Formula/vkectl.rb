class Vkectl < Formula
  desc "Command-Line Interface for VKE(VolcanoEngine Kubernetes Engine)"
  homepage "https://github.com/volcengine/vkectl"
  url "https://github.com/volcengine/vkectl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "15f0f3786c03d53702306ba4ae8812afe59e0094356d1202c292cca87242ac77"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vkectl"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2030441d1775307b5041868e28d913817c560d363710aa0f14d02e33f038b35e"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/volcengine/vkectl/pkg/version.version=v#{version}"), "./main"

    generate_completions_from_executable(bin/"vkectl", "completion")
  end

  test do
    version_out = shell_output("#{bin}/vkectl version")
    assert_match version.to_s, version_out

    resource_help_out = shell_output("#{bin}/vkectl resource -h")
    assert_match "AddNodes", resource_help_out

    resource_get_addon_out = shell_output("#{bin}/vkectl resource GetAddon")
    resource_get_addon_index = resource_get_addon_out.index("{")
    assert_empty JSON.parse(resource_get_addon_out[resource_get_addon_index..])["Name"]

    security_get_check_item_out = shell_output("#{bin}/vkectl security GetCheckItem")
    security_get_check_item_index = security_get_check_item_out.index("{")
    assert_empty JSON.parse(security_get_check_item_out[security_get_check_item_index..])["Number"]
  end
end
