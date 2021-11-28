class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.26.0.tar.gz"
  sha256 "e24db4279d3386700e25f3eb3ae4115ed11f4e0b2eea16d28f2113c71d13fb5b"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kompose"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "557eb485692a88928f3a5927e93f7a747a71e666132bc41627b7f90e7dec8c3b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    output = Utils.safe_popen_read(bin/"kompose", "completion", "bash")
    (bash_completion/"kompose").write output

    output = Utils.safe_popen_read(bin/"kompose", "completion", "zsh")
    (zsh_completion/"_kompose").write output

    output = Utils.safe_popen_read(bin/"kompose", "completion", "fish")
    (fish_completion/"kompose.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
