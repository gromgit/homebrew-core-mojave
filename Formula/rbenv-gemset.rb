class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/v0.5.10.tar.gz"
  sha256 "91b9e6f0cced09a40df5817277c35c654d39feaea4318cc63a5962689b649c94"
  license :public_domain
  head "https://github.com/jf/rbenv-gemset.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rbenv-gemset"
    sha256 cellar: :any_skip_relocation, mojave: "7db514b2352ec2cd623ebf7efe1feebb8125960531fbeda72e7a4e37cfe576f6"
  end

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end
