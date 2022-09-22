class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.26.1.tar.gz"
  sha256 "58547107377705f48cd02e391a5faf441dc0c861aeb9bc17c7c46e9de3ae1806"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kompose"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "7cc00c1b1ea57be91ec133e93aae794c6789c0e1b5d5141cdc7e3a8294d417bb"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
