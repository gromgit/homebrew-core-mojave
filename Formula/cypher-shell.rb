class CypherShell < Formula
  desc "Command-line shell where you can execute Cypher against Neo4j"
  homepage "https://neo4j.com"
  url "https://dist.neo4j.org/cypher-shell/cypher-shell-5.3.0.zip"
  sha256 "2ab684982a94fefde0c18c71fc8376bc32a2e283795569a405aed2d307084888"
  license "GPL-3.0-only"
  version_scheme 1

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?cypher-shell[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1539eaed9a81d80efa0561b81da2221fc9c16ea24f72b9fa170d2e6d8e8437a3"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"cypher-shell").write_env_script libexec/"bin/cypher-shell", Language::Java.overridable_java_home_env
  end

  test do
    # The connection will fail and print the name of the host
    assert_match "doesntexist", shell_output("#{bin}/cypher-shell -a bolt://doesntexist 2>&1", 1)
  end
end
