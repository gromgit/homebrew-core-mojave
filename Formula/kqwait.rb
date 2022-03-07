class Kqwait < Formula
  desc "Wait for events on files or directories on macOS"
  homepage "https://github.com/sschober/kqwait"
  url "https://github.com/sschober/kqwait/archive/kqwait-v1.0.3.tar.gz"
  sha256 "878560936d473f203c0ccb3d42eadccfb50cff15e6f15a59061e73704474c531"
  license "BSD-2-Clause"
  head "https://github.com/sschober/kqwait.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kqwait"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "d65acfc55f19885b734e8f9280345dd999ad95666d4a2ee634f9974fd5eb9f9c"
  end

  def install
    system "make"
    bin.install "kqwait"
  end

  test do
    system "#{bin}/kqwait", "-v"
  end
end
