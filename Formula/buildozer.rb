class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/5.0.1.tar.gz"
  sha256 "7f43df3cca7bb4ea443b4159edd7a204c8d771890a69a50a190dc9543760ca21"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildozer"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "378ffbe2d20a0ab47b8383fa9353f6e500e1691f12005598e2984025d8d05ad6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./buildozer"
  end

  test do
    build_file = testpath/"BUILD"

    touch build_file
    system "#{bin}/buildozer", "new java_library brewed", "//:__pkg__"

    assert_equal "java_library(name = \"brewed\")\n", build_file.read
  end
end
