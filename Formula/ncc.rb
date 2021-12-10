require "language/node"

class Ncc < Formula
  desc "Compile a Node.js project into a single file"
  homepage "https://github.com/vercel/ncc"
  url "https://registry.npmjs.org/@vercel/ncc/-/ncc-0.33.0.tgz"
  sha256 "b68d97e75d77463863ff03a72cb6ecf19df50021ca8934ec36594ab769e112d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4d9a4c2963e94dc83d568933b55ba7db2a00923a0ce57f1984186681683a24cc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"input.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"ncc", "build", "input.js", "-o", "dist"
    assert_match "document.createElement", File.read("dist/index.js")
  end
end
