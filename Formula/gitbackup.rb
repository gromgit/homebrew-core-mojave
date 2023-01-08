class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.8.4.tar.gz"
  sha256 "1d110658874dcb96d9de7cdbb7a54bdaa6e01a77a2952bf881a20d58235d1e7a"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gitbackup"
    sha256 cellar: :any_skip_relocation, mojave: "49652ac6fe5956d0cec9417b2338b57d9eaa8aeeec5705a29ff3d07aec22d85f"
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
