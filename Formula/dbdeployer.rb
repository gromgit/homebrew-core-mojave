class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.69.1.tar.gz"
  sha256 "165950a32760a5e0f32f951eaa0c67a6956cb2cea75ac0381c65f39b7e9789c7"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dbdeployer"
    sha256 cellar: :any_skip_relocation, mojave: "c7e4edd5f5d13874b73f7dfa4fa2bbd86c71179d65bcb82a7cd246a0add4fcb6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
