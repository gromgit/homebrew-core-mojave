class WiremockStandalone < Formula
  desc "Simulator for HTTP-based APIs"
  homepage "https://wiremock.org/docs/running-standalone/"
  url "https://search.maven.org/remotecontent?filepath=com/github/tomakehurst/wiremock-jre8-standalone/2.34.0/wiremock-jre8-standalone-2.34.0.jar"
  sha256 "7708232b423eb4dca7eb1d9de9dc43693aa465e572fae5f6c46ae1faafae0b48"
  license "Apache-2.0"
  head "https://github.com/tomakehurst/wiremock.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "241aa43f895e0419ba47f5cc35fa2642014c32943f842c68a198eaa167c78f16"
  end

  depends_on "openjdk"

  def install
    libexec.install "wiremock-jre8-standalone-#{version}.jar"
    bin.write_jar_script libexec/"wiremock-jre8-standalone-#{version}.jar", "wiremock"
  end

  test do
    port = free_port

    wiremock = fork do
      exec "#{bin}/wiremock", "-port", port.to_s
    end

    loop do
      Utils.popen_read("curl", "-s", "http://localhost:#{port}/__admin/", "-X", "GET")
      break if $CHILD_STATUS.exitstatus.zero?
    end

    system "curl", "-s", "http://localhost:#{port}/__admin/shutdown", "-X", "POST"

    Process.wait(wiremock)
  end
end
