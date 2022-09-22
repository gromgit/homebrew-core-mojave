class Mapcidr < Formula
  desc "Subnet/CIDR operation utility"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/mapcidr/archive/v1.0.2.tar.gz"
  sha256 "c77ba39d93566512cacea672c4c595881fe4a36b29fab909fd61aba80b0646db"
  license "MIT"
  head "https://github.com/projectdiscovery/mapcidr.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mapcidr"
    sha256 cellar: :any_skip_relocation, mojave: "02f9db4a67a50f79a3fd62ab2719b59e6df8c29909c5b925398f4b261cd9581e"
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
