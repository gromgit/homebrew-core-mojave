class ElbTools < Formula
  desc "Client interface to the Amazon Elastic Load Balancing web service"
  homepage "https://aws.amazon.com/developertools/2536"
  url "https://ec2-downloads.s3.amazonaws.com/ElasticLoadBalancing.zip"
  version "1.0.35.0"
  sha256 "31d9aa0ca579c270f8e3579f967b6048bc070802b7b41a30a9fa090fbffba62b"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8dd3007e8367fe8e0c4b4b85889a68d7196a954a27add9cb163c5965daa51da1"
  end

  depends_on "ec2-api-tools"
  depends_on "openjdk"

  def install
    env = { JAVA_HOME: Formula["openjdk"].opt_prefix, AWS_ELB_HOME: libexec }
    rm Dir["bin/*.cmd"] # Remove Windows versions
    libexec.install Dir["*"]
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "service"

      (bin/basename).write_env_script file, env
    end
  end

  def caveats
    <<~EOS
      Before you can use these tools you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_CREDENTIAL_FILE="<Path to the credentials file>"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/elb-version")
  end
end
