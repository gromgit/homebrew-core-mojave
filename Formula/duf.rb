class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.8.0.tar.gz"
  sha256 "6b483e68ec783821d07f03cb85629832b8c6f302a7d1bca25af142f891381e8b"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duf"
    sha256 cellar: :any_skip_relocation, mojave: "eab2485bf3467c0be77983348430656856faad10d6b8b2947162bd6448c15536"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    require "json"

    devices = JSON.parse shell_output("#{bin}/duf --json")
    assert root = devices.find { |d| d["mount_point"] == "/" }
    assert_equal "local", root["device_type"]
  end
end
