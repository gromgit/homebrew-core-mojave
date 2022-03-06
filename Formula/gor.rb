class Gor < Formula
  desc "Real-time HTTP traffic replay tool written in Go"
  homepage "https://goreplay.org"
  url "https://github.com/buger/goreplay.git",
      tag:      "1.3.3",
      revision: "f8ef77e8cf4aae59029daf6cbd2fc784af811cee"
  license "LGPL-3.0-only"
  head "https://github.com/buger/goreplay.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gor"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fb75aa29e93945581b738de4432c0ccad0d125a209671b99b0b20ef956844ad3"
  end

  depends_on "go" => :build

  uses_from_macos "netcat" => :test
  uses_from_macos "libpcap"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=#{version}")
  end

  test do
    test_port = free_port
    fork do
      exec bin/"gor", "file-server", ":#{test_port}"
    end

    sleep 2
    system "nc", "-z", "localhost", test_port
  end
end
