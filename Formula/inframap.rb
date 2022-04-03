class Inframap < Formula
  desc "Read your tfstate or HCL to generate a graph"
  homepage "https://github.com/cycloidio/inframap"
  url "https://github.com/cycloidio/inframap/archive/v0.6.7.tar.gz"
  sha256 "e9d6daa48c6fa1a8ecc5437c7121cb5072eb81c29c88ca9e6d778637c8442332"
  license "MIT"
  head "https://github.com/cycloidio/inframap.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/inframap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a2bec3d6d608a98565f84ca866312a2906e33e834481f4909107f4d548a4f7b1"
  end

  depends_on "go" => :build

  resource "test_resource" do
    url "https://raw.githubusercontent.com/cycloidio/inframap/7ef22e7/generate/testdata/azure.tfstate"
    sha256 "633033074a8ac43df3d0ef0881f14abd47a850b4afd5f1fbe02d3885b8e8104d"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/cycloidio/inframap/cmd.Version=v#{version}")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/inframap version")
    testpath.install resource("test_resource")
    output = shell_output("#{bin}/inframap generate --tfstate #{testpath}/azure.tfstate")
    assert_match "strict digraph G {", output
    assert_match "\"azurerm_virtual_network.myterraformnetwork\"->\"azurerm_virtual_network.myterraformnetwork2\";",
      output
  end
end
