class CfrDecompiler < Formula
  desc "Yet Another Java Decompiler"
  homepage "https://www.benf.org/other/cfr/"
  url "https://github.com/leibnitz27/cfr.git",
      tag:      "0.152",
      revision: "68477be3ff7171ee17ddd1a26064b9b253f1604f"
  license "MIT"
  head "https://github.com/leibnitz27/cfr.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?cfr[._-]v?(\d+(?:\.\d+)+)\.jar/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cfr-decompiler"
    sha256 cellar: :any_skip_relocation, mojave: "4407a9af52161440872e2904803137007690cc8d6f6255cc522466945b91d259"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    # Homebrew's OpenJDK no longer accepts Java 6 source, so:
    inreplace "pom.xml", "<javaVersion>1.6</javaVersion>", "<javaVersion>1.7</javaVersion>"
    inreplace "cfr.iml", 'LANGUAGE_LEVEL="JDK_1_6"', 'LANGUAGE_LEVEL="JDK_1_7"'

    # build
    ENV["JAVA_HOME"] = Formula["openjdk"].opt_prefix
    system Formula["maven"].bin/"mvn", "package"

    cd "target" do
      # switch on jar names
      if build.head?
        lib_jar = Dir["cfr-*-SNAPSHOT.jar"]
        doc_jar = Dir["cfr-*-SNAPSHOT-javadoc.jar"]
        odie "Unexpected number of artifacts!" if (lib_jar.length != 1) || (doc_jar.length != 1)
        lib_jar = lib_jar[0]
        doc_jar = doc_jar[0]
      else
        lib_jar = "cfr-#{version}.jar"
        doc_jar = "cfr-#{version}-javadoc.jar"
      end

      # install library and binary
      libexec.install lib_jar
      (bin/"cfr-decompiler").write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        exec "${JAVA_HOME}/bin/java" -jar "#{libexec/lib_jar}" "$@"
      EOS

      # install library docs
      doc.install doc_jar
      mkdir doc/"javadoc"
      cd doc/"javadoc" do
        system Formula["openjdk"].bin/"jar", "-xf", doc/doc_jar
        rm_rf "META-INF"
      end
    end
  end

  test do
    fixture = <<~EOS
      /*
       * Decompiled with CFR #{version}.
       */
      class T {
          T() {
          }

          public static void main(String[] stringArray) {
              System.out.println("Hello brew!");
          }
      }
    EOS
    (testpath/"T.java").write fixture
    system Formula["openjdk"].bin/"javac", "T.java"
    output = pipe_output("#{bin}/cfr-decompiler --comments false T.class")
    assert_match fixture, output
  end
end
