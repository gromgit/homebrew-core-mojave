class Tika < Formula
  desc "Content analysis toolkit"
  homepage "https://tika.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=tika/2.2.0/tika-app-2.2.0.jar"
  mirror "https://archive.apache.org/dist/tika/2.2.0/tika-app-2.2.0.jar"
  sha256 "fc5697c725cc091c004e2c80034f8fca06748a7276e36e6f6b225b4bc76627c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2654871c700d815f4b3fa8a8db634ab442a6fd512db639f99460c5032643e09f"
  end

  depends_on "openjdk"

  resource "server" do
    url "https://www.apache.org/dyn/closer.lua?path=tika/2.2.0/tika-server-standard-2.2.0.jar"
    mirror "https://archive.apache.org/dist/tika/2.2.0/tika-server-standard-2.2.0.jar"
    sha256 "5049043fccf5ddc3c545851e0d45d0f73be20d7a7cc2b833fbd99c2d70f316f1"
  end

  def install
    libexec.install "tika-app-#{version}.jar"
    bin.write_jar_script libexec/"tika-app-#{version}.jar", "tika"

    libexec.install resource("server")
    bin.write_jar_script libexec/"tika-server-#{version}.jar", "tika-rest-server"
  end

  test do
    pdf = test_fixtures("test.pdf")
    assert_equal "application/pdf\n", shell_output("#{bin}/tika --detect #{pdf}")
  end
end
