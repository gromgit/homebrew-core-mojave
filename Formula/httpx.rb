class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.3.tar.gz"
  sha256 "c0c688705fdf16c250d8de5a20737c37a7b786effe9e764fbac6be05504d9e5e"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/httpx"
    sha256 cellar: :any_skip_relocation, mojave: "19cf43cb8b8f9c5a3088f9ade7faa17f4b65d532bb972bfcec7c2efecabfa012"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/httpx"
  end

  test do
    output = JSON.parse(pipe_output("#{bin}/httpx -silent -status-code -title -json", "example.org"))
    assert_equal 200, output["status-code"]
    assert_equal "Example Domain", output["title"]
  end
end
