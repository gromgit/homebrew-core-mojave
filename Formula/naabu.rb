class Naabu < Formula
  desc "Fast port scanner"
  homepage "https://github.com/projectdiscovery/naabu"
  url "https://github.com/projectdiscovery/naabu/archive/v2.0.9.tar.gz"
  sha256 "cdfc2dcc4dfc52370882b9e244d6dcbb8650dc9c4af3f3c6f7ff7a2b805cff0c"
  license "MIT"
  head "https://github.com/projectdiscovery/naabu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/naabu"
    sha256 cellar: :any_skip_relocation, mojave: "caed1a6349077a8f04bd7b88093691651025e0508709f968ce2adb1677261ca3"
  end

  depends_on "go" => :build

  uses_from_macos "libpcap"

  def install
    cd "v2" do
      system "go", "build", *std_go_args, "./cmd/naabu"
    end
  end

  test do
    assert_match "brew.sh:443", shell_output("#{bin}/naabu -host brew.sh -p 443")
  end
end
