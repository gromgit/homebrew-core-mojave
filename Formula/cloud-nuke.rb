class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.7.1.tar.gz"
  sha256 "79e05807b6f9282749eb4459e49c00671d76c7b0d87e234b6dfc949c634b283d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cloud-nuke"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0c57f6ec42b15e87f87d8d219f4ef3d6098c6c6490fd8dec1d9022a815e98e5d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
