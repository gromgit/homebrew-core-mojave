class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.13.0.tar.gz"
  sha256 "73af6b8c765bf05abd6e9c209772db686b881a1c6d534542cd35de80743a1b34"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaegi"
    sha256 cellar: :any_skip_relocation, mojave: "35b0d97a21398b3187404959c050a1db524bf6ef48379e5893fcf1f16be9a816"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
