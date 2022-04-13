class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.25.0.tar.gz"
  sha256 "c8ae52a07d06f416ba9439f0b8fa9163c6f19ca4520a941eb4f6aa5452682017"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matterbridge"
    sha256 cellar: :any_skip_relocation, mojave: "cfefdea49b16153820cfea1a0fe039aacdd19beacf96c778a32fa8a7290f8aea"
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
