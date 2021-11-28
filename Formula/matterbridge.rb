class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.23.2.tar.gz"
  sha256 "5f00556b89855db7ce171c91552f51de1d053e463b8c858049a872fadd5c22a6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matterbridge"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "68b99a2b466485691d8760d3d93c7e87eb1df33e7c9ca89e2750cd5b5ca60300"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
