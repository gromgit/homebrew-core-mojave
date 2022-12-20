class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.19.1/nifi-registry-1.19.1-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.19.1/nifi-registry-1.19.1-bin.zip"
  sha256 "a09db8b0787c8d9bb01130f6d5075154a306e42173ec60622fc96a5f2548b8b2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c4d58d05237eb6f5a2a607942a894ff02781fc6289a005a314a82fa48a611c5"
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
