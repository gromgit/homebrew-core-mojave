class Gx < Formula
  desc "Language-agnostic, universal package manager"
  homepage "https://github.com/whyrusleeping/gx"
  url "https://github.com/whyrusleeping/gx/archive/v0.14.3.tar.gz"
  sha256 "2c0b90ddfd3152863f815c35b37e94d027216c6ba1c6653a94b722bf6e2b015d"
  license "MIT"
  head "https://github.com/whyrusleeping/gx.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gx"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "905bb40f6f4310b37abcf7aba287021c6844318b61a754d48163b39cf1ccb46a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"gx"
  end

  test do
    assert_match "ERROR: no package found in this directory or any above", shell_output("#{bin}/gx deps", 1)
  end
end
