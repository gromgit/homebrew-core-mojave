class Buildozer < Formula
  desc "Rewrite bazel BUILD files using standard commands"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.3.tar.gz"
  sha256 "614c84128ddb86aab4e1f25ba2e027d32fd5c6da302ae30685b9d7973b13da1b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildozer"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "5b08df64857f61502054aa5057119f25a62b02c8d44c895b33f21cf9d16e7c8a"
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
