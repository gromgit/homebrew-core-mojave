class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.27.1.tgz"
  sha256 "ef7e261dd5f3304488536b70d9ea37c4405f2bfea3a85fc113d0513967fcfdf8"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pnpm"
    sha256 cellar: :any_skip_relocation, mojave: "0605044cff0b88c6b24f34c271fab8dc170c8698748feeafd29cc6279c786094"
  end

  depends_on "node"

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
