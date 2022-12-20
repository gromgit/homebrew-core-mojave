class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.19.1/nifi-1.19.1-bin.zip"
  mirror " https://archive.apache.org/dist/nifi/1.19.1/nifi-1.19.1-bin.zip"
  sha256 "aa4c0ff9336b46a82224c8c10f6eea2d6124003ff4d73bb940ad54ae95ae866f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4559bc862f9d1e1838feb2c9c84748b1f81ef43bc7ee3e81af13cfbc4fb35693"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
