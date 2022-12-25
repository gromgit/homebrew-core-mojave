class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/v0.1.7.tar.gz"
  sha256 "bc42551bde3ce61500d0eea3f4443e29bc2c5d86b1f01e87f929c46ce308ca9a"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chain-bench"
    sha256 cellar: :any_skip_relocation, mojave: "cfc88728b547bb622ee760b1041bf8809f19fbad3f0afdc53bf06ecafb495803"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    repo_url = "https://github.com/Homebrew/homebrew-core"
    assert_match "Fetch Starting", shell_output("#{bin}/chain-bench scan --repository-url #{repo_url}")

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
