class RushParallel < Formula
  desc "Cross-platform command-line tool for executing jobs in parallel"
  homepage "https://github.com/shenwei356/rush"
  url "https://github.com/shenwei356/rush/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8046a0ac9ed10d2adff250ab5b95a95c895cae3b43d2a25bd95979f319146cb9"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rush-parallel"
    sha256 cellar: :any_skip_relocation, mojave: "c0e0c311497ea2fea9a6ea137ce2b9bd9079e1264da5e3cec414127e98b0efbb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"rush")
  end

  test do
    assert_equal <<~EOS, pipe_output("#{bin}/rush -k 'echo 0{}'", (1..4).to_a.join("\n"))
      01
      02
      03
      04
    EOS
  end
end
