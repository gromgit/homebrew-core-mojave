class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "6a14d0354ba635c8fc188c351e59dbc057d61de3dc6a8d6a17fb4cecde260114"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lefthook"
    sha256 cellar: :any_skip_relocation, mojave: "0d9f686fba0e554e250850920f3d6842a4913879af5b66ed8eab9dadc0910824"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
