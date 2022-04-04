class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.26.1.tar.gz"
  sha256 "58547107377705f48cd02e391a5faf441dc0c861aeb9bc17c7c46e9de3ae1806"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kompose"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "7230ae9590b965ccd24db4653af289b2c97203bd9e25fbd1687e4d9ba57415d0"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
