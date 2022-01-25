class Tomcat < Formula
  desc "Implementation of Java Servlet and JavaServer Pages"
  homepage "https://tomcat.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.16/bin/apache-tomcat-10.0.16.tar.gz"
  sha256 "4931f74f8b564d937a95b8afca43a187b94489c2a1fa4d17551acb6cca2d5051"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "83d762ee3f4e01e282ddbe8262fc6b2e2257f057a69ae4b2ca0a5b0288860655"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]

    pkgetc.install Dir["conf/*"]
    (buildpath/"conf").rmdir
    libexec.install_symlink pkgetc => "conf"

    libexec.install Dir["*"]
    (bin/"catalina").write_env_script "#{libexec}/bin/catalina.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def caveats
    <<~EOS
      Configuration files: #{pkgetc}
    EOS
  end

  service do
    run [opt_bin/"catalina", "run"]
    keep_alive true
  end

  test do
    ENV["CATALINA_BASE"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{libexec}/logs/*"]

    pid = fork do
      exec bin/"catalina", "start"
    end
    sleep 3
    begin
      system bin/"catalina", "stop"
    ensure
      Process.wait pid
    end
    assert_predicate testpath/"logs/catalina.out", :exist?
  end
end
