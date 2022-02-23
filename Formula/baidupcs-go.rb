class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.7.tar.gz"
  sha256 "e365fabee470ea5ab51b9ba034b5168dca1d0d537ab36274a17bfc460036b965"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/baidupcs-go"
    sha256 cellar: :any_skip_relocation, mojave: "3800c02b62fa9d220ee75f68d043575674e9918a21f4929e0256ed332fa1d260"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"baidupcs-go", "run", "touch", "test.txt"
    assert_predicate testpath/"test.txt", :exist?
  end
end
