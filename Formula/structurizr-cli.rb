class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.16.0/structurizr-cli-1.16.0.zip"
  sha256 "718cce6aa86274ebca0eabb6843cd9be8c3c65d84829d9ac5c2e3ef48138c133"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1924ea5277dae163236bc5607f4ed1b3c3d04b3daa5f134f830fd8002a53cfb1"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    expected_output = <<~EOS.strip
      Structurizr CLI v#{version}
      Structurizr DSL v#{version}
      Usage: structurizr push|pull|lock|unlock|export|validate|list [options]
    EOS
    result = pipe_output("#{bin}/structurizr-cli").strip
    assert_equal result, expected_output
  end
end
