class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.15.3/nifi-registry-1.15.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.15.3/nifi-registry-1.15.3-bin.tar.gz"
  sha256 "4d10c2599b48aa1311b6c692f0bb533d1cada4935667945077a837430c21a285"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4bbe9182edea8ff8a95a6b85f62d6eb8fcade7f057fa057d347fb3f5157f351f"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/",
                             Language::Java.overridable_java_home_env.merge(NIFI_REGISTRY_HOME: libexec)
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end
