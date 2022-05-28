require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-1.4.2.tgz"
  sha256 "6a365afc8a67d865416e0627eeb7e9512cd0b1686fc80072750b7de075c863b6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mongosh"
    sha256 mojave: "eee75ba41f27a196b85c7fe1fcc944c2df5340c6e875c6ed73fb27bd9ce328b8"
  end

  depends_on "node@16"

  def install
    system "#{Formula["node@16"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node@16"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
  end
end
