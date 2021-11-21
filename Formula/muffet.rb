class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.5.tar.gz"
  sha256 "370c8d5d179f0edad4cebd1fe5b27b87dd19014f982c5b1a17fd34b7a07c93f4"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/muffet"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cf67eb3cb1f8e5520c8e301358c3ed354a745de308c6aa73a3579013246bd229"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match(/failed to fetch root page: lookup does\.not\.exist.*: no such host/,
                 shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1))

    assert_match "https://httpbin.org/",
                 shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
