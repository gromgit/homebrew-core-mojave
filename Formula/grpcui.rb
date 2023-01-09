class Grpcui < Formula
  desc "Interactive web UI for gRPC, along the lines of postman"
  homepage "https://github.com/fullstorydev/grpcui"
  url "https://github.com/fullstorydev/grpcui/archive/v1.3.1.tar.gz"
  sha256 "01cfa0bbaf9cfdaa61ae0341c83cde3372854133d62cb9b91c3a111eaa145815"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grpcui"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "cec68b29431a11408a12d7a1d9abb1d15cd6136787217760d4c5264b88867f56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/grpcui"
  end

  test do
    host = "no.such.host.dev"
    output = shell_output("#{bin}/grpcui #{host}:999 2>&1", 1)
    assert_match(/Failed to dial target host "#{Regexp.escape(host)}:999":.*: no such host/, output)
  end
end
