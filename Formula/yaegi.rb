class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.12.0.tar.gz"
  sha256 "caad3b3f2272aa31c8a853a383a2199fc7fc11d54e186bd3dbb80ced6da64e56"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaegi"
    sha256 cellar: :any_skip_relocation, mojave: "cd7c2dada7fb19987a7fca35bff2298a062ab867fa8b30de95bf18eaa0c202cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
