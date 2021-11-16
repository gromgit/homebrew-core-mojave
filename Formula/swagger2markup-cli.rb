class Swagger2markupCli < Formula
  desc "Swagger to AsciiDoc or Markdown converter"
  homepage "https://github.com/Swagger2Markup/swagger2markup"
  url "https://search.maven.org/remotecontent?filepath=io/github/swagger2markup/swagger2markup-cli/1.3.3/swagger2markup-cli-1.3.3.jar"
  sha256 "93ff10990f8279eca35b7ac30099460e557b073d48b52d16046ab1aeab248a0a"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fa6afa6aa54f25247e0cd6f2f10561354603995295d6ea952a9ca971ecae64e6"
  end

  depends_on "openjdk@11"

  def install
    libexec.install "swagger2markup-cli-#{version}.jar"
    bin.write_jar_script libexec/"swagger2markup-cli-#{version}.jar", "swagger2markup", java_version: "11"
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      swagger: "2.0"
      info:
        version: "1.0.0"
        title: TestSpec
        description: Example Swagger spec
      host: localhost:3000
      paths:
        /test:
          get:
            responses:
              "200":
                description: Describe the test resource
    EOS
    shell_output("#{bin}/swagger2markup convert -i test.yaml -f test")
    assert_match "= TestSpec", shell_output("head -n 1 test.adoc")
  end
end
