class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.0.tar.gz"
  sha256 "dc033a6fb4f31520ab1bb403dd910aed04037964ab1406363cce2185a8bd3d3b"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dust"
    sha256 cellar: :any_skip_relocation, mojave: "77b897ef115bcbfbdd25d66bbe33bac9d97601b146d883eea52033356eb18f61"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
