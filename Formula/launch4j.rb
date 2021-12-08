class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "https://launch4j.sourceforge.io/"
  url "https://git.code.sf.net/p/launch4j/git.git",
      tag:      "Release_launch4j-3_14",
      revision: "46db737fd1885203fb098f4368cd5cf5c6792373"
  license all_of: ["BSD-3-Clause", "MIT"]
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/launch4j"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "c7e895f8c432bfd7482f1daee534ad66a79e1c5b52c95c578fba5ddce5c4c069"
  end

  depends_on "ant" => :build
  depends_on arch: :x86_64
  # Installs a pre-built `ld` and `windres` file with linkage to zlib
  depends_on :macos
  depends_on "openjdk"

  def install
    system "ant", "compile"
    system "ant", "jar"
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end

  test do
    system "#{bin}/launch4j", "--version"
  end
end
