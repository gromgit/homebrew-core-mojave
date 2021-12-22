class Coursier < Formula
  desc "Pure Scala Artifact Fetching"
  homepage "https://get-coursier.io/"
  url "https://github.com/coursier/coursier/releases/download/v2.1.0-M2/coursier.jar"
  sha256 "fda87fc2d52b96a338b38c3b1c69a33fb0a0dd57fb2ab5d7880164c0ea9234f2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5096cf898c56949605292c2054a673746622ff424cd6baaac4b52c52791d93bd"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "coursier.jar"
    chmod 0755, libexec/"bin/coursier.jar"
    (bin/"coursier").write_env_script libexec/"bin/coursier.jar", Language::Java.overridable_java_home_env
  end

  test do
    system bin/"coursier", "list"
    assert_match "scalafix", shell_output("#{bin}/coursier search scalafix")
  end
end
