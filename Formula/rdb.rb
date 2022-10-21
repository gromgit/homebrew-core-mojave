class Rdb < Formula
  desc "Redis RDB parser"
  homepage "https://github.com/HDT3213/rdb/"
  url "https://github.com/HDT3213/rdb/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "a0b1dc198f9d38c36f0f6e502644ea060c84d352303cd53055497f0211871f13"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rdb"
    sha256 cellar: :any_skip_relocation, mojave: "dcde61bc57b4e60c478974e4076068748474d5bf6ed923b3d5fa9a73ab1dc809"
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
