class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.1.tar.gz"
  sha256 "5f3313c3f226cdcb374631036b1187cfd52a857769ec254ac659098082a4e94d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitbackup"
    sha256 cellar: :any_skip_relocation, mojave: "9f3476c0755cd6dae2943a47c61f33ec95157db8bac12790174779f24aa23450"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
