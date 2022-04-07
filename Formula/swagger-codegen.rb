class SwaggerCodegen < Formula
  desc "Generate clients, server stubs, and docs from an OpenAPI spec"
  homepage "https://swagger.io/swagger-codegen/"
  url "https://github.com/swagger-api/swagger-codegen/archive/v3.0.33.tar.gz"
  sha256 "be4b07522d8bd06e39b2c72043251f9a6d8619686f06bac4cf37e976090271f7"
  license "Apache-2.0"
  head "https://github.com/swagger-api/swagger-codegen.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/swagger-codegen"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9d3e68c96275535d2df4f17fa1eae6dc69fb40bd65157a096e9e86cabfbb51d4"
  end

  depends_on "maven" => :build
  depends_on "openjdk@11"

  def install
    # Need to set JAVA_HOME manually since maven overrides 1.8 with 1.7+
    ENV["JAVA_HOME"] = Formula["openjdk@11"].opt_prefix

    system "mvn", "clean", "package"
    libexec.install "modules/swagger-codegen-cli/target/swagger-codegen-cli.jar"
    bin.write_jar_script libexec/"swagger-codegen-cli.jar", "swagger-codegen", java_version: "11"
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      openapi: 3.0.0
      info:
        version: 0.0.0
        title: Simple API
      paths:
        /:
          get:
            responses:
              200:
                description: OK
    EOS
    system "#{bin}/swagger-codegen", "generate", "-i", "minimal.yaml", "-l", "html"
    assert_includes File.read(testpath/"index.html"), "<h1>Simple API</h1>"
  end
end
