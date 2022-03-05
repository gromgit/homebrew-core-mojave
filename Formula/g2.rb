class G2 < Formula
  desc "Friendly git client"
  homepage "https://orefalo.github.io/g2/"
  url "https://github.com/orefalo/g2/archive/v1.1.tar.gz"
  sha256 "bc534a4cb97be200ba4e3cc27510d8739382bb4c574e3cf121f157c6415bdfba"
  license "MIT"
  head "https://github.com/orefalo/g2.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/g2"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d15f084c0e5f1d9ff6268cf0589e37bf2d917c7d999aec872447a6a8f88b62a8"
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  def caveats
    <<~EOS
      To complete the installation:
        . #{prefix}/g2-install.sh

      NOTE: This will install a new ~/.gitconfig, backing up any existing
      file first. For more information view:
        #{prefix}/README.md
    EOS
  end
end
