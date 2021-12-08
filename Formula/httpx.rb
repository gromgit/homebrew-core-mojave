class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.1.4.tar.gz"
  sha256 "9726db14c0f13ccd12de84f4766c815100a52fbb755c4fdfc8a6f645daf81241"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/httpx"
    sha256 cellar: :any_skip_relocation, mojave: "7ca9a4f62bf38abbeec93ad280e828853630eb4e836688fc5a6c2e5c21a17c52"
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
