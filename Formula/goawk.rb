class Goawk < Formula
  desc "POSIX-compliant AWK interpreter written in Go"
  homepage "https://benhoyt.com/writings/goawk/"
  url "https://github.com/benhoyt/goawk/archive/refs/tags/v1.17.1.tar.gz"
  sha256 "43054fbe53922807d97816be802a39a9485c71369eb74f9ed2c2877dcb4d3629"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/goawk"
    sha256 cellar: :any_skip_relocation, mojave: "19bc3568f3bbdb2590d6982978ae71491c37da34858119bf1e5041381edf0f21"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = pipe_output("#{bin}/goawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
