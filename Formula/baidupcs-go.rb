class BaidupcsGo < Formula
  desc "Terminal utility for Baidu Network Disk"
  homepage "https://github.com/qjfoidnh/BaiduPCS-Go"
  url "https://github.com/qjfoidnh/BaiduPCS-Go/archive/v3.8.5.tar.gz"
  sha256 "0d1a95b6ae3e6fb330d157368337ee1c596498eb4a10c5984c3ee100e981506c"
  license "Apache-2.0"
  head "https://github.com/qjfoidnh/BaiduPCS-Go.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/baidupcs-go"
    sha256 cellar: :any_skip_relocation, mojave: "e3e22d0fb0ec6c15565ad9f611504116df83c6f8ec0fde814bd99138d853495f"
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
