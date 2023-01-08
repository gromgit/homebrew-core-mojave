class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "https://tcnksm.github.io/ghr"
  url "https://github.com/tcnksm/ghr/archive/v0.16.0.tar.gz"
  sha256 "c2b1f0a25b3e0b9016418c125441f16615387e32bce5c56049064deffbe1b1c9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghr"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d7e7c95d1d0725d9216c0533b44280da433f81bd1340ba815410b116ebfafa49"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["GITHUB_TOKEN"] = nil
    args = "-username testbot -repository #{testpath} v#{version} #{Dir.pwd}"
    assert_includes "token not found", shell_output("#{bin}/ghr #{args}", 15)
  end
end
