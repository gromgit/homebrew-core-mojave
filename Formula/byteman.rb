class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/4.0.17/byteman-download-4.0.17-bin.zip"
  sha256 "ba65c26dbebf8febf579d41a8849020f8381d5edaf3f48625a64962e8185dabc"
  license "LGPL-2.1-or-later"
  head "https://github.com/bytemanproject/byteman.git", branch: "main"

  livecheck do
    url "https://byteman.jboss.org/downloads.html"
    regex(/href=.*?byteman-download[._-]v?(\d+(?:\.\d+)+)-bin\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fd05bdb8caaf686dae2c5117372f4c7b4e9f2e9f97504583aedd6352ba13f189"
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    doc.install Dir["docs/*"], "README"
    libexec.install ["bin", "lib", "contrib"]
    pkgshare.install ["sample"]

    env = { JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}", BYTEMAN_HOME: libexec }
    Pathname.glob("#{libexec}/bin/*") do |file|
      target = bin/File.basename(file, File.extname(file))
      # Drop the .sh from the scripts
      target.write_env_script(libexec/"bin/#{File.basename(file)}", env)
    end
  end

  test do
    (testpath/"src/main/java/BytemanHello.java").write <<~EOS
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    EOS

    (testpath/"brew.btm").write <<~EOS
      RULE trace main entry
      CLASS BytemanHello
      METHOD main
      AT ENTRY
      IF true
      DO traceln("Entering main")
      ENDRULE

      RULE trace main exit
      CLASS BytemanHello
      METHOD main
      AT EXIT
      IF true
      DO traceln("Exiting main")
      ENDRULE
    EOS

    system "#{Formula["openjdk"].bin}/javac", "src/main/java/BytemanHello.java"

    actual = shell_output("#{bin}/bmjava -l brew.btm -cp src/main/java BytemanHello")
    assert_match("Hello, Brew!", actual)
  end
end
