class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.10.tar.gz"
  sha256 "982fe4e84aaadbcb04ee5bca2f7859b9e789d172e6b8641dec447246f4567aff"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frugal"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1d013f82eb43c8c604b042db1b1d1586d4167fd21227701050b7024a995a2564"
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
