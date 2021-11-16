class Maven < Formula
  desc "Java-based project management"
  homepage "https://maven.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/maven/maven-3/3.8.3/binaries/apache-maven-3.8.3-bin.tar.gz"
  sha256 "0f1597d11085b8fe93d84652a18c6deea71ece9fabba45a02cf6600c7758fd5b"
  license "Apache-2.0"

  livecheck do
    url "https://maven.apache.org/download.cgi"
    regex(/href=.*?apache-maven[._-]v?(\d+(?:\.\d+)+)-bin\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b99fa79e0cc7c21da43f4132298fba36ebda6755d18d787c5c96e18c2693d6f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5316ed4579d366299cad35d57376413ef5942be27e9def61967b417468b8e2d"
    sha256 cellar: :any_skip_relocation, monterey:       "521dbfe0030a04fd9f8232270633d093c1fd9e8f649195e3af1f74432fb25809"
    sha256 cellar: :any_skip_relocation, big_sur:        "e20b223a764265a88cd00a3a526fcafdda834a038dccfef6ad63d551dd6d5594"
    sha256 cellar: :any_skip_relocation, catalina:       "e20b223a764265a88cd00a3a526fcafdda834a038dccfef6ad63d551dd6d5594"
    sha256 cellar: :any_skip_relocation, mojave:         "e20b223a764265a88cd00a3a526fcafdda834a038dccfef6ad63d551dd6d5594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07797e93cf8c6f358b149d6bfc31da7b65b469d2585b2efaa7ce36741bc1887f"
  end

  depends_on "openjdk"

  conflicts_with "mvnvm", because: "also installs a 'mvn' executable"

  def install
    # Remove windows files
    rm_f Dir["bin/*.cmd"]

    # Fix the permissions on the global settings file.
    chmod 0644, "conf/settings.xml"

    libexec.install Dir["*"]

    # Leave conf file in libexec. The mvn symlink will be resolved and the conf
    # file will be found relative to it
    Pathname.glob("#{libexec}/bin/*") do |file|
      next if file.directory?

      basename = file.basename
      next if basename.to_s == "m2.conf"

      (bin/basename).write_env_script file, Language::Java.overridable_java_home_env
    end
  end

  test do
    (testpath/"pom.xml").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <project xmlns="https://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="https://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
        <modelVersion>4.0.0</modelVersion>
        <groupId>org.homebrew</groupId>
        <artifactId>maven-test</artifactId>
        <version>1.0.0-SNAPSHOT</version>
        <properties>
          <maven.compiler.source>1.8</maven.compiler.source>
          <maven.compiler.target>1.8</maven.compiler.target>
          <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        </properties>
      </project>
    EOS
    (testpath/"src/main/java/org/homebrew/MavenTest.java").write <<~EOS
      package org.homebrew;
      public class MavenTest {
        public static void main(String[] args) {
          System.out.println("Testing Maven with Homebrew!");
        }
      }
    EOS
    system "#{bin}/mvn", "compile", "-Duser.home=#{testpath}"
  end
end
