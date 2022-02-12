class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.4.tar.gz"
  sha256 "b5e07e462288715de4648ff59485167caf2316da6993d7c4634dc06c45cb667d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/okteto"
    sha256 cellar: :any_skip_relocation, mojave: "bfc7d460f5030f3f65a4ef3dd178c803a0eec07175e795c46e7a5aa139c66ac3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
