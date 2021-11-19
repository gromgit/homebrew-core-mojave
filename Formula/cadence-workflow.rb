class CadenceWorkflow < Formula
  desc "Distributed, scalable, durable, and highly available orchestration engine"
  homepage "https://cadenceworkflow.io/"
  url "https://github.com/uber/cadence.git",
      tag:      "v0.22.4",
      revision: "c04d7641bd091586593832ee30b94a05c1f44cf4"
  license "MIT"
  head "https://github.com/uber/cadence.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cadence-workflow"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "26b49500ade872e9ab9fc991434c911b9a70652e948557d5fc47dabf480699a5"
  end

  depends_on "go" => :build

  conflicts_with "cadence", because: "both install an `cadence` executable"

  def install
    system "make", ".fake-codegen"
    system "make", "cadence", "cadence-server", "cadence-canary", "cadence-sql-tool", "cadence-cassandra-tool"
    bin.install "cadence"
    bin.install "cadence-server"
    bin.install "cadence-canary"
    bin.install "cadence-sql-tool"
    bin.install "cadence-cassandra-tool"

    (etc/"cadence").install "config", "schema"
  end

  test do
    output = shell_output("#{bin}/cadence-server start 2>&1", 1)
    assert_match "Loading config; env=development,zone=,configDir", output

    output = shell_output("#{bin}/cadence --domain samples-domain domain desc ", 1)
    assert_match "Error: Operation DescribeDomain failed", output
  end
end
