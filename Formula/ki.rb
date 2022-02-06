class Ki < Formula
  desc "Kotlin Language Interactive Shell"
  homepage "https://github.com/Kotlin/kotlin-interactive-shell"
  url "https://github.com/Kotlin/kotlin-interactive-shell/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "b5e38918ac64216713c64170fd12f7b2c7c00124ba8d8b10ae7e53b386cb4bab"
  license "Apache-2.0"
  head "https://github.com/Kotlin/kotlin-interactive-shell.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ki"
    sha256 cellar: :any_skip_relocation, mojave: "0c3265602a7dc11280221611430d73d15bce8d0c0265d3dd2f50f52b1c628a60"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix
    system "mvn", "-DskipTests", "package"
    libexec.install "lib/ki-shell.jar"
    bin.write_jar_script libexec/"ki-shell.jar", "ki", java_version: "11"
  end

  test do
    output = pipe_output(bin/"ki", ":q")
    assert_match "ki-shell", output
    assert_match "Bye!", output
  end
end
