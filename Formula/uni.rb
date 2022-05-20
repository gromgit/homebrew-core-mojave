class Uni < Formula
  desc "Unicode database query tool for the command-line"
  homepage "https://github.com/arp242/uni"
  url "https://github.com/arp242/uni/archive/v2.5.1.tar.gz"
  sha256 "806fbba66efaa45cd5691efcd8457ba8fe88d3b2f6fd0b027f1e6ef62253d6fb"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/uni"
    sha256 cellar: :any_skip_relocation, mojave: "6910a5e7993ab53eadd2a96cd04b2931df98fa95bc41c7ac63d64705042e14ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "CLINKING BEER MUGS", shell_output("#{bin}/uni identify 🍻")
  end
end
