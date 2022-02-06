class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.26/htmlcleaner-2.26-src.zip"
  sha256 "617ddb866530f512c2c6f6f89b40a9ac6e46bf515960c49f47d8d037adaf0e2c"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/htmlcleaner"
    sha256 cellar: :any_skip_relocation, mojave: "30573ff47a7b85f50af7626f6839ef962590c1f9429847714bd5503bc159ebb7"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix

    inreplace "pom.xml" do |s|
      # Homebrew's OpenJDK no longer accepts Java 5 source
      s.gsub! "<source>1.5</source>", "<source>1.7</source>"
      s.gsub! "<target>1.5</target>", "<target>1.7</target>"
      # OpenJDK >14 doesn't support older maven-javadoc-plugin versions
      s.gsub! "<version>2.9</version>", "<version>3.2.0</version>"
    end

    system "mvn", "clean", "package", "-DskipTests=true", "-Dmaven.javadoc.skip=true"
    libexec.install Dir["target/htmlcleaner-*.jar"]
    bin.write_jar_script libexec/"htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
