class Buildifier < Formula
  desc "Format bazel BUILD files with a standard convention"
  homepage "https://github.com/bazelbuild/buildtools"
  url "https://github.com/bazelbuild/buildtools/archive/4.2.3.tar.gz"
  sha256 "614c84128ddb86aab4e1f25ba2e027d32fd5c6da302ae30685b9d7973b13da1b"
  license "Apache-2.0"
  head "https://github.com/bazelbuild/buildtools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/buildifier"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "46b656e9a2a94354a1ee38c5dcaef99b935ebb19040f615ef5575e3352f6bb65"
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
