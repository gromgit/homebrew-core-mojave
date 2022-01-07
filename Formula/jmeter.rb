class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.4.3.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.3.tgz"
  sha256 "72521214c0cb87dac5b974c1c6e83a17a009c7fd377b55bf23525c72403b1dee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71af8d00cd769598a7a1291565a1d15d97f9ef78ea4dc23d0025b8d4d503e76a"
  end

  depends_on "openjdk"

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.7/jmeter-plugins-manager-1.7.jar"
    sha256 "2ae43743c5bc73d557e08e79fb9b137d301626bb393c2c03aa381b1dc8fc40ed"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"jmeter").write_env_script libexec/"bin/jmeter", JAVA_HOME: Formula["openjdk"].opt_prefix

    resource("jmeter-plugins-manager").stage do
      (libexec/"lib/ext").install Dir["*"]
    end
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
