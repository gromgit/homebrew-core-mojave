class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.24.0.tar.gz"
  sha256 "65ee39770b4799ebbe6676206cae3d067b4c7ea29773a1e7fb26c657d4b151a6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matterbridge"
    sha256 cellar: :any_skip_relocation, mojave: "da800035d043a45f892aa0998b259699fe38705579622e83956252a57f567130"
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
