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
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5357c4713bb663ad650fe7c9fe6ff3f204650e5c3b0202463ec7feeb7b29cd6d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
