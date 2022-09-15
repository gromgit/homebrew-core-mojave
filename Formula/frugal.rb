class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.3.tar.gz"
  sha256 "dc72ac8609bfadacb2610b3c5683318c3a30201098f486417f11d72fae55ee1d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frugal"
    sha256 cellar: :any_skip_relocation, mojave: "2a6d1d8ff2e2ea10e40d9a16459e55647fb7b4fbc13157e89d7455f4cc2d4299"
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
