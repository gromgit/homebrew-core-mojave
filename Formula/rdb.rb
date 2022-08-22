class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "156df3d22f5291cba6da07808d43a3add2e97a9c054316c53f296e2ab0ab9829"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rdb"
    sha256 cellar: :any_skip_relocation, mojave: "ee0282138fdd04224590f440c36b38bd1d0da20bf83d0c43b9138016a16e5a27"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    pkgshare.install "cases"
  end

  test do
    cp_r pkgshare/"cases", testpath
    system bin/"rdb", "-c", "memory", "-o", testpath/"mem1.csv", testpath/"cases/memory.rdb"
    assert_equal (testpath/"cases/memory.csv").read, (testpath/"mem1.csv").read
  end
end
