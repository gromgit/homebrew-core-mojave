class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.0.tar.gz"
  sha256 "f4f5c478f966a1d60373c74bfa1e934c9858c0502e2da1819ca00ef7e0fb1ee1"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/httpx"
    sha256 cellar: :any_skip_relocation, mojave: "084e9e7d47622453a3a7a9905323656a77c5a2c4d6403719cd0f663398d1a56f"
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
