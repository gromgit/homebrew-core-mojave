class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.1.tar.gz"
  sha256 "7f43df3cca7bb4ea443b4159edd7a204c8d771890a69a50a190dc9543760ca21"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildifier"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0274576ac925ec2fc71b9f6354ea796c31d6036cd5933847a54d761727d3d1ed"
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
