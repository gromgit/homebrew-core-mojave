class Liquigraph < Formula
  desc "Migration runner for Neo4j"
  homepage "https://www.liquigraph.org/"
  url "https://github.com/liquigraph/liquigraph/archive/liquigraph-4.0.6.tar.gz"
  sha256 "c51283a75346f8d4c7bb44c6a39461eb3918ac5b150ec3ae157f9b12c4150566"
  license "Apache-2.0"
  head "https://github.com/liquigraph/liquigraph.git", branch: "4.x"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liquigraph"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "ecd9e1d3f50b0baa706518be19d0e85c528efdc12f77d92c5080a0907f298598"
  end

  deprecate! date: "2022-02-21", because: :unsupported

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "mvn", "-B", "-q", "-am", "-pl", "liquigraph-cli", "clean", "package", "-DskipTests"
    (buildpath/"binaries").mkpath
    system "tar", "xzf", "liquigraph-cli/target/liquigraph-cli-bin.tar.gz", "-C", "binaries"
    libexec.install "binaries/liquigraph-cli/liquigraph.sh"
    libexec.install "binaries/liquigraph-cli/liquigraph-cli.jar"
    (bin/"liquigraph").write_env_script libexec/"liquigraph.sh", JAVA_HOME: "${JAVA_HOME:-#{ENV["JAVA_HOME"]}}"
  end

  test do
    failing_hostname = "verrryyyy_unlikely_host"
    changelog = testpath/"changelog"
    changelog.write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <changelog>
          <changeset id="hello-world" author="you">
              <query>CREATE (n:Sentence {text:'Hello monde!'}) RETURN n</query>
          </changeset>
          <changeset id="hello-world-fixed" author="you">
              <query>MATCH (n:Sentence {text:'Hello monde!'}) SET n.text='Hello world!' RETURN n</query>
          </changeset>
      </changelog>
    EOS

    jdbc = "jdbc:neo4j:http://#{failing_hostname}:7474/"
    output = shell_output("#{bin}/liquigraph "\
                          "dry-run -d #{testpath} "\
                          "--changelog #{changelog.realpath} "\
                          "--graph-db-uri #{jdbc} 2>&1", 1)
    assert_match "Exception: #{failing_hostname}", output
  end
end
