require "language/node"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https://www.typescriptlang.org/"
  url "https://registry.npmjs.org/typescript/-/typescript-4.5.4.tgz"
  sha256 "5b2b014c4d6f9ad4615d7ced8cc32f882a4a96df8213722577b42277afb03cba"
  license "Apache-2.0"
  head "https://github.com/Microsoft/TypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e21cc29d7cc58885cd8f3fff15000b4d7aeb304e7b6725b4d4329a8504a9763"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin/"tsc", "test.ts"
    assert_predicate testpath/"test.js", :exist?, "test.js was not generated"
  end
end
