class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.4.tar.gz"
  sha256 "207aa3dfc45f0c18b4486469a3705a58d863a08f8715ec394cf05af747ff6df6"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frugal"
    sha256 cellar: :any_skip_relocation, mojave: "3c1ccef6aad6ca0e8b3f60adf34fea9735ce439fbb8f0e7d947d0ed1fb6e3084"
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
