class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://github.com/livekit/livekit-cli/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "3d2b781142342bfe56150fa723b5072f4b6174a23ce6c8a6d75a45bdba0b88f0"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/livekit-cli"
    sha256 cellar: :any_skip_relocation, mojave: "05c74d0f8d5b3224a9fd99e3468a7b308cfbef70f958a840dfdb051b0f26bbad"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/livekit-cli"
  end

  test do
    output = shell_output("#{bin}/livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}/livekit-cli --version")
  end
end
