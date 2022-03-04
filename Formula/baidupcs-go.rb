class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.7.tar.gz"
  sha256 "e365fabee470ea5ab51b9ba034b5168dca1d0d537ab36274a17bfc460036b965"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/baidupcs-go"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cc93b627f70fd087cc8dd21265d8ae2f0b1b7424392f9e37acc8ab8c45a91507"
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
