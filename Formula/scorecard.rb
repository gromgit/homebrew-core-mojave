class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/v3.2.1.tar.gz"
  sha256 "009183faea28c561f60f2c7bd84e477130d16e55d581bc354879c66e7123cdd2"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scorecard"
    sha256 cellar: :any_skip_relocation, mojave: "9e84da3033fe7efabed98fecc13931e320f79b10a9fdc1687b70b3f91eafb392"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    cd("docs/checks/internal/generate") { system "go", "run", "main.go", "../../checks.md" }
    doc.install "docs/checks.md"
  end

  test do
    ENV["GITHUB_AUTH_TOKEN"] = "test"
    output = shell_output("#{bin}/scorecard --repo=github.com/kubernetes/kubernetes --checks=Maintained 2>&1", 1)
    expected_output = "InitRepo: repo unreachable: GET https://api.github.com/repos/google/oss-fuzz: 401"
    assert_match expected_output, output
  end
end
