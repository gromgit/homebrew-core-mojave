class TomeePlus < Formula
  desc "Everything in TomEE Web Profile and JAX-RS, plus more"
  homepage "https://tomee.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tomee/tomee-8.0.9/apache-tomee-8.0.9-plus.tar.gz"
  mirror "https://archive.apache.org/dist/tomee/tomee-8.0.9/apache-tomee-8.0.9-plus.tar.gz"
  sha256 "9867429f19aa5df2fd8e9bebedfb5cfd4e2b31cb7019bf8e6a9597349bb892c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75e617bf21f00f3b8834e09b98fcd6b6a5704b2f6d419c1213ab115ee2c1ced5"
  end

  depends_on "openjdk"

  def install
    # Remove Windows scripts
    rm_rf Dir["bin/*.bat"]
    rm_rf Dir["bin/*.bat.original"]
    rm_rf Dir["bin/*.exe"]

    # Install files
    prefix.install %w[NOTICE LICENSE RELEASE-NOTES RUNNING.txt]
    libexec.install Dir["*"]
    (bin/"tomee-plus-startup").write_env_script "#{libexec}/bin/startup.sh",
                                                Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      The home of Apache TomEE Plus is:
        #{opt_libexec}
      To run Apache TomEE:
        #{opt_libexec}/bin/tomee-plus-startup
    EOS
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system "#{opt_libexec}/bin/configtest.sh"
  end
end
