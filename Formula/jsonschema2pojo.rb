class Jsonschema2pojo < Formula
  desc "Generates Java types from JSON Schema (or example JSON)"
  homepage "https://www.jsonschema2pojo.org/"
  url "https://github.com/joelittlejohn/jsonschema2pojo/releases/download/jsonschema2pojo-1.1.3/jsonschema2pojo-1.1.3.tar.gz"
  sha256 "03c4a2fc1c50d8ca600ef3ad640143539e983290744b833bc58632232eba3ab4"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/jsonschema2pojo[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6e84b730b1e3d0632f7b6a8a0060b5940e882b02a32463d5a69dd87091e728d1"
  end

  depends_on "openjdk"

  def install
    libexec.install "jsonschema2pojo-#{version}-javadoc.jar", "lib"
    bin.write_jar_script libexec/"lib/jsonschema2pojo-cli-#{version}.jar", "jsonschema2pojo"
  end

  test do
    (testpath/"src/jsonschema.json").write <<~EOS
      {
        "type":"object",
        "properties": {
          "foo": {
            "type": "string"
          },
          "bar": {
            "type": "integer"
          },
          "baz": {
            "type": "boolean"
          }
        }
      }
    EOS
    system bin/"jsonschema2pojo", "-s", "src", "-t", testpath
    assert_predicate testpath/"Jsonschema.java", :exist?, "Failed to generate Jsonschema.java"
  end
end
