class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.21.0.tar.gz"
  sha256 "0ccf1375ee3c20508c37de288a46faa6b0e4dffb3a3749f4b699a30f95e861be"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stern"
    sha256 cellar: :any_skip_relocation, mojave: "57ec2f922e695d8a1b0e7761abfa130c8975dc25d8ab16cfa4952299a77b0ea9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/stern/stern/cmd.version=#{version}")

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=fish")
    (fish_completion/"stern.fish").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
