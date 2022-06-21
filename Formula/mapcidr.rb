class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.0.0.tar.gz"
  sha256 "2e3a0fc4301c6c5ebee75a9c6b7dd2e1c646dc5d67b74f97dc3e2eb187a133de"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mapcidr"
    sha256 cellar: :any_skip_relocation, mojave: "500cc34247d9e8194513049f0f47b41e2426f5693d6991a6e194b9e5d5f09684"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/mapcidr"
  end

  test do
    expected = "192.168.0.0/18\n192.168.64.0/18\n192.168.128.0/18\n192.168.192.0/18\n"
    output = shell_output("#{bin}/mapcidr -cidr 192.168.1.0/16 -sbh 16384 -silent")
    assert_equal expected, output
  end
end
