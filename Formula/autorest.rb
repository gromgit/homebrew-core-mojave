require "language/node"

class Autorest < Formula
  desc "Swagger (OpenAPI) Specification code generator"
  homepage "https://github.com/Azure/autorest"
  url "https://registry.npmjs.org/autorest/-/autorest-3.6.1.tgz"
  sha256 "a517e0e9dee7b3d36e4e03fd78e3f6bd7792de824e2faec2b64e44f2c2034758"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/autorest"
    sha256 cellar: :any_skip_relocation, mojave: "ec88baabdae6900f41ea43ead3b79bba2d5cda45e2b73fd996f7778b86f63b62"
  end

  depends_on "node"

  resource "homebrew-petstore" do
    url "https://raw.githubusercontent.com/Azure/autorest/5c170a02c009d032e10aa9f5ab7841e637b3d53b/Samples/1b-code-generation-multilang/petstore.yaml"
    sha256 "e981f21115bc9deba47c74e5c533d92a94cf5dbe880c4304357650083283ce13"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    resource("homebrew-petstore").stage do
      system (bin/"autorest"), "--input-file=petstore.yaml",
                               "--typescript",
                               "--output-folder=petstore"
      assert_includes File.read("petstore/package.json"), "Microsoft Corporation"
    end
  end
end
