class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.23.2.tar.gz"
  sha256 "5f00556b89855db7ce171c91552f51de1d053e463b8c858049a872fadd5c22a6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matterbridge"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "41520d7a7fb4ef0cec3b0bb17b1988e83d01f9d0429100bc1e69991bd8e37ba1"
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
