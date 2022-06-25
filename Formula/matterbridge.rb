class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.25.2.tar.gz"
  sha256 "e078a4776b1082230ea0b8146613679c23d3b0d322706c987261df987a04bfc5"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matterbridge"
    sha256 cellar: :any_skip_relocation, mojave: "b34b748c53d4fca1a85a8c2f40bcdcc698f792fe02cb3290c258045e2eeaaecb"
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
