class StructurizrCli < Formula
  desc "Command-line utility for Structurizr"
  homepage "https://structurizr.com"
  url "https://github.com/structurizr/cli/releases/download/v1.20.0/structurizr-cli-1.20.0.zip"
  sha256 "d04d4c22aeeecd04ff1ba7154b14d6aba9d512740ff75293270b456f239b8d4b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1af144e2697850f9e00da435caf9760d6769b602fbb8db93b60b254f8cfdf8f2"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["*.bat"]
    libexec.install Dir["*"]
    (bin/"structurizr-cli").write_env_script libexec/"structurizr.sh", Language::Java.overridable_java_home_env
  end

  test do
    result = pipe_output("#{bin}/structurizr-cli").strip
    # not checking `Structurizr DSL` version as it is different binary
    assert_match "Structurizr CLI v#{version}", result
    assert_match "Usage: structurizr push|pull|lock|unlock|export|validate|list [options]", result
  end
end
