class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  url "https://github.com/hashicorp/waypoint/archive/v0.7.2.tar.gz"
  sha256 "da89019fad31ca583c8c8327c8da00fb4a76c278ff1c53583c842bb827496558"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/waypoint"
    sha256 cellar: :any_skip_relocation, mojave: "10b532994c88fad770c50e34387d6772d425617ab290d2ac907cb0087e45fa0b"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  test do
    assert_match "Initial Waypoint configuration created!", shell_output("#{bin}/waypoint init")
    assert_match "# An application to deploy.", File.read("waypoint.hcl")

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
