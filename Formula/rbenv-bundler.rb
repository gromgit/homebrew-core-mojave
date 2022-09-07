class RbenvBundler < Formula
  desc "Makes shims aware of bundle install paths"
  homepage "https://github.com/carsomyr/rbenv-bundler"
  url "https://github.com/carsomyr/rbenv-bundler/archive/1.0.1.tar.gz"
  sha256 "6840d4165242da4606cd246ee77d484a91ee926331c5a6f840847ce189f54d74"
  license "Apache-2.0"
  head "https://github.com/carsomyr/rbenv-bundler.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rbenv-bundler"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0f9e6f5d1c17a8608e940404724286aa2ac1f4efaa23feaaeef106aee49048c9"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "bundler.bash", shell_output("rbenv hooks exec")
  end
end
