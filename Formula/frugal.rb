class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.14.15.tar.gz"
  sha256 "e05879b91c80e5654394decd37b89d06cf7d67e76f544aecb9642778c6e8d06a"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frugal"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "98b079890e59e2de08b011ae5bf7e91e21790574e1606397a8cc8e2e349fbfd7"
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
