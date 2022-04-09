class Aspectj < Formula
  desc "Aspect-oriented programming for Java"
  homepage "https://www.eclipse.org/aspectj/"
  url "https://github.com/eclipse/org.aspectj/releases/download/V1_9_9_1/aspectj-1.9.9.1.jar"
  sha256 "922310b843d7a12a4752222791f62cadf08071273a997e364d12016de210856b"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:_\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/aspectj"
    sha256 cellar: :any_skip_relocation, mojave: "84663e1bdd543e19c32d104e143809f941f31fdd565cad2df3f2b231c0ffbbac"
  end

  depends_on "openjdk"

  def install
    mkdir_p "#{libexec}/#{name}"
    system "#{Formula["openjdk"].bin}/java", "-jar", "aspectj-#{version}.jar", "-to", "#{libexec}/#{name}"
    bin.install Dir["#{libexec}/#{name}/bin/*"]
    bin.env_script_all_files libexec/"#{name}/bin", Language::Java.overridable_java_home_env
    chmod 0555, Dir["#{libexec}/#{name}/bin/*"] # avoid 0777
  end

  test do
    (testpath/"Test.java").write <<~EOS
      public class Test {
        public static void main (String[] args) {
          System.out.println("Brew Test");
        }
      }
    EOS
    (testpath/"TestAspect.aj").write <<~EOS
      public aspect TestAspect {
        private pointcut mainMethod () :
          execution(public static void main(String[]));

          before () : mainMethod() {
            System.out.print("Aspect ");
          }
      }
    EOS
    ENV["CLASSPATH"] = "#{libexec}/#{name}/lib/aspectjrt.jar:test.jar:testaspect.jar"
    system bin/"ajc", "-outjar", "test.jar", "Test.java"
    system bin/"ajc", "-outjar", "testaspect.jar", "-outxml", "TestAspect.aj"
    output = shell_output("#{bin}/aj Test")
    assert_match "Aspect Brew Test", output
  end
end
