class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.0.tar.gz"
  sha256 "b94bc7c55b5c086ba1504adceef74d0f0eb8c159f94cb84b23863e97f74fe217"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitbackup"
    sha256 cellar: :any_skip_relocation, mojave: "464f30bd128dfb46f01bace2f652a9175c8d5dd03ce8d997ae03acb92bc8662f"
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
