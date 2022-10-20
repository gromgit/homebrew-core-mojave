class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.4.tar.gz"
  sha256 "dcfb329ab790dc55bf168f0eecc7d84a33bf07bf5e6da1c8e5ca5f66adabea1e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frugal"
    sha256 cellar: :any_skip_relocation, mojave: "b6489d87d0c15286b1f9120a4776373a1e3c300ab47891c450e4670e56e3efc5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
