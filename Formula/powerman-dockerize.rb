class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "b6507b24714dee193bd04be18fe8658531d2b0c0b9f6f060ac6bb387c736009f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/powerman-dockerize"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8c20cd070564dbd41c5133f68120a25ed20d10aba6b9004aad125cfcb8643649"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
