class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/v0.1.3.tar.gz"
  sha256 "46b63528ddd0e09b65539a69aefbf4229343e636854d0dd5a241870717843423"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/chain-bench"
    sha256 cellar: :any_skip_relocation, mojave: "f441cc1fa0580a1a77f314b6afb58014363c00ae094f54d9702bc85facdae539"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"
  end

  test do
    assert_match("Fetch Starting", shell_output("#{bin}/chain-bench scan", 1))

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
