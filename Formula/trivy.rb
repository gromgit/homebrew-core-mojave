class Trivy < Formula
  desc "Vulnerability scanner for container images, file systems, and Git repos"
  homepage "https://aquasecurity.github.io/trivy/"
  url "https://github.com/aquasecurity/trivy/archive/v0.31.2.tar.gz"
  sha256 "3058e1b6fed23c1cad10b6b9d950174a6579083821b1ef6788efaf3955bf3253"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/trivy.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/trivy"
    sha256 cellar: :any_skip_relocation, mojave: "36d6bd59f5f24a1e5f1db6640bac1f36a72dae8ad75ecc3dd402b4b0a1e17882"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/trivy"
  end

  test do
    output = shell_output("#{bin}/trivy image alpine:3.10")
    assert_match(/\(UNKNOWN: \d+, LOW: \d+, MEDIUM: \d+, HIGH: \d+, CRITICAL: \d+\)/, output)

    assert_match version.to_s, shell_output("#{bin}/trivy --version")
  end
end
