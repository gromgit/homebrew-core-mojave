class Neo4j < Formula
  desc "Robust (fully ACID) transactional property graph database"
  homepage "https://neo4j.com/"
  url "https://neo4j.com/artifact.php?name=neo4j-community-4.4.11-unix.tar.gz"
  sha256 "28810daac5de4a5d5b77ce2da7d7c3da4c5ccf13288bad885b833c35b96100c8"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://neo4j.com/download-center/"
    regex(/href=.*?edition=community[^"' >]+release=v?(\d+(?:\.\d+)+)[&"' >]
          |href=.*?release=v?(\d+(?:\.\d+)+)[^"' >]+edition=community/ix)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "73bc7b410291367f0e77f403bd3fb49c118a2ff828afbabf9030a9a98dbce383"
  end

  depends_on "openjdk@11"

  def install
    env = {
      JAVA_HOME:  Formula["openjdk@11"].opt_prefix,
      NEO4J_HOME: libexec,
    }
    # Remove windows files
    rm_f Dir["bin/*.bat"]

    # Install jars in libexec to avoid conflicts
    libexec.install Dir["*"]

    # Symlink binaries
    bin.install Dir["#{libexec}/bin/neo4j{,-shell,-import,-shared.sh,-admin}", "#{libexec}/bin/cypher-shell"]
    bin.env_script_all_files(libexec/"bin", env)

    # Adjust UDC props
    # Suppress the empty, focus-stealing java gui.
    (libexec/"conf/neo4j.conf").append_lines <<~EOS
      wrapper.java.additional=-Djava.awt.headless=true
      wrapper.java.additional.4=-Dneo4j.ext.udc.source=homebrew
      dbms.directories.data=#{var}/neo4j/data
      dbms.directories.logs=#{var}/log/neo4j
    EOS
  end

  def post_install
    (var/"log/neo4j").mkpath
    (var/"neo4j").mkpath
  end

  service do
    run [opt_bin/"neo4j", "console"]
    keep_alive false
    working_dir var
    log_path var/"log/neo4j.log"
    error_log_path var/"log/neo4j.log"
  end

  test do
    ENV["NEO4J_HOME"] = libexec
    ENV["NEO4J_LOG"] = testpath/"libexec/data/log/neo4j.log"
    ENV["NEO4J_PIDFILE"] = testpath/"libexec/data/neo4j-service.pid"
    mkpath testpath/"libexec/data/log"
    assert_match(/Neo4j .*is not running/i, shell_output("#{bin}/neo4j status", 3))
  end
end
