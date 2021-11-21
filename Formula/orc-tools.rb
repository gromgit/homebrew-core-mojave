class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.7.1/orc-tools-1.7.1-uber.jar"
  sha256 "53c7eae1399135227c89eecc5ec63d156bcaa753b8c1b4b69e30680e386f17a0"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/orc-tools"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fa8952ccc0cf4cc84aa2baa8e9c6a2ec4f5f5777363be867a0f53c9f971f1bf0"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
