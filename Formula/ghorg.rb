class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.8.7.tar.gz"
  sha256 "0a4c7f8051d8351508510148e01c965a10490d97362b9c14407d0d19d7fd7778"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ghorg"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6311eb45432b9c07fa4d1b1ff5bab86fdb2e6630e33c3d6dd013e57fb0cfe6ed"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", "completion")
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
