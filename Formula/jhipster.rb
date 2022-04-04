require "language/node"

class Jhipster < Formula
  desc "Generate, develop and deploy Spring Boot + Angular/React applications"
  homepage "https://www.jhipster.tech/"
  # Check if this can be switched to the newest `node` at version bump
  url "https://registry.npmjs.org/generator-jhipster/-/generator-jhipster-7.7.0.tgz"
  sha256 "561c55ad290f8325093c791e4e2125fbbce49f1c58031246934a988bafde3e94"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jhipster"
    sha256 cellar: :any_skip_relocation, mojave: "1dccc4cc310a73f1da28b30579fbccb8f4c0a203f5688d04abd15b8b07febc0b"
  end

  depends_on "node"
  depends_on "openjdk"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "execution is complete", shell_output("#{bin}/jhipster info")
  end
end
