class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-4.0.0.zip"
  sha256 "bd5b8af69c169f41c5c7aea00cb8832a6e232ee697f626e29d8f92adebe30df9"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c3fd88a48dc33553032d34b4806f442e6e7ef5e1d74fb8da551624570c41890b"
  end

  depends_on "openjdk"

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/groovy.ico"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    system "#{bin}/grape", "install", "org.activiti", "activiti-engine", "5.16.4"
  end
end
