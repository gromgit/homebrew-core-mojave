class RbenvCommunalGems < Formula
  desc "Share gems across multiple rbenv Ruby installs"
  homepage "https://github.com/tpope/rbenv-communal-gems"
  url "https://github.com/tpope/rbenv-communal-gems/archive/v1.0.1.tar.gz"
  sha256 "99f1c0be6721e25037f964015cbd2622d70603ceeeaef58f040410ac3697d766"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4cd057a73659f1fdea3a0d266485367b960378c790eef4c6d7b707a4936c8481"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "communal-gems.bash", shell_output("rbenv hooks install")
  end
end
