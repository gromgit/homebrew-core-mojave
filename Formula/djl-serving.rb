class DjlServing < Formula
  desc "This module contains an universal model serving implementation"
  homepage "https://github.com/deepjavalibrary/djl-serving"
  url "https://publish.djl.ai/djl-serving/serving-0.18.0.tar"
  sha256 "badc950b17870710e67079bcfaee1fb2b2d23fd2288a3895489d459f135b8e0c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d13fca5ba4f5e05482e007e56377a94b8cb12e10ebc33cadc75846b56d77a0f"
  end

  depends_on "openjdk"

  def install
    # Install files
    rm_rf Dir["bin/*.bat"]
    mv "bin/serving", "bin/djl-serving"
    libexec.install Dir["*"]
    env = { MODEL_SERVER_HOME: "${MODEL_SERVER_HOME:-#{var}}" }
    env.merge!(Language::Java.overridable_java_home_env)
    (bin/"djl-serving").write_env_script "#{libexec}/bin/djl-serving", env
  end

  service do
    run [opt_bin/"djl-serving", "run"]
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.properties").write <<~EOS
      inference_address=http://127.0.0.1:#{port}
      management_address=http://127.0.0.1:#{port}
    EOS
    ENV["MODEL_SERVER_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    fork do
      exec bin/"djl-serving -f config.properties"
    end
    sleep 30
    cmd = "http://127.0.0.1:#{port}/ping"
    assert_match "{}\n", shell_output("curl --fail #{cmd}")
  end
end
