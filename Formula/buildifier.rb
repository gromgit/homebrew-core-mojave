class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.1.tar.gz"
  sha256 "7f43df3cca7bb4ea443b4159edd7a204c8d771890a69a50a190dc9543760ca21"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildifier"
    sha256 cellar: :any_skip_relocation, mojave: "59b2312bf1a953388c55e9cc8e451b0461b220244c504ab581449258b2dfcfb1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildifier"
  end

  test do
    touch testpath/"BUILD"
    system "#{bin}/buildifier", "-mode=check", "BUILD"
  end
end
