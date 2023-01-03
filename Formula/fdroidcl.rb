class Fdroidcl < Formula
  desc "F-Droid desktop client"
  homepage "https://github.com/mvdan/fdroidcl"
  url "https://github.com/mvdan/fdroidcl/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "532a8c4c93216cbf13378ff409c06a08d48e8baee6119a50ed43dc0ce9ec7879"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/fdroidcl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fdroidcl"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "9366c66e3d46bb1ccc671e729d1b6cde60be403eda35929441f352487b3f7dd6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "done", shell_output("#{bin}/fdroidcl update")
  end
end
