class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/dehydrated-io/dehydrated/archive/v0.7.1.tar.gz"
  sha256 "3d993237af5abd4ee83100458867454ed119e41fac72b3d2bce9efc60d4dff32"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dehydrated"
    sha256 cellar: :any_skip_relocation, mojave: "ebef64bfbbb961baab69a546da164867b6d3d0acc2090b6f0a8d9d1b2e6ac26b"
  end

  def install
    bin.install "dehydrated"
    man1.install "docs/man/dehydrated.1"
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
