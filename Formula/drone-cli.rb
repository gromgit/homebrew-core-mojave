class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
      tag:      "v1.5.0",
      revision: "92e84c4e2452f82ad093722d87ad054e1821805e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/drone-cli"
    sha256 cellar: :any_skip_relocation, mojave: "a1a10d06405e26d4ea66b82906d3493d23d517f6c6ac037a8e2e031ba192e57c"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
