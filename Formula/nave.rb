class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.3.1.tar.gz"
  sha256 "c5789615135cf1b0b55c9e7422735bc8af4a2eee717cc09c0d520cfe88cc68a0"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nave"
    sha256 cellar: :any_skip_relocation, mojave: "1f245fcfdd7109a0939d1cb82a854407ac78bedb2bf140966b0d736c69e9a9a4"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
