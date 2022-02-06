class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.2.3.tar.gz"
  sha256 "cd7c1f6f87b1dd83cbed52b5f101bb4fce8448030be85f5de034599179d84b78"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nave"
    sha256 cellar: :any_skip_relocation, mojave: "617b3d4825d3fa11020eb73f5bdcd4ee5b2844b5bab084ef7ed821c588a32fac"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
