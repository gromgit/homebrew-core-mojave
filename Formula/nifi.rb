class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.15.3/nifi-1.15.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.15.3/nifi-1.15.3-bin.tar.gz"
  sha256 "c77fe8e4bc534f16fd5482832285e0bde07495308f31fd6d0fbb3118042daed4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a687b3a904f7fcd693d26be80c101146750910d4892f0b2ff44ef9247fd3246"
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
