class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.16.1.tar.gz"
  sha256 "e201f1e8108bf21a2d921c6446ce4eada01d5c238c626d4813ffb7bf412a3d01"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frugal"
    sha256 cellar: :any_skip_relocation, mojave: "0b6136e88d974483d401167b3b1d25f6d126bd23010ed740b0d35e7fa6cf0e54"
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
