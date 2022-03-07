class Hr < Formula
  desc "<hr />, for your terminal window"
  homepage "https://github.com/LuRsT/hr"
  url "https://github.com/LuRsT/hr/archive/1.3.tar.gz"
  sha256 "258ff3121369d17c5c70fa18e466ac01cdb4cf890c605f7a5e706d5b1a3afebf"
  license "MIT"
  head "https://github.com/LuRsT/hr.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hr"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "4c98d40a979dbd2c905c79eae280575dc320dbaa9528da0547cc4d19686b8b61"
  end

  def install
    bin.install "hr"
    man1.install "hr.1"
  end

  test do
    system "#{bin}/hr", "-#-"
  end
end
