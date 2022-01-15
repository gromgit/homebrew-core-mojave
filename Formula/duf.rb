class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.7.0.tar.gz"
  sha256 "6f70fd0f0d51bfcfe20b8acc8c3a52573fc1ceed44ce97dbbb9d470bbe4467dc"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duf"
    sha256 cellar: :any_skip_relocation, mojave: "91f5b21829679cd1ee9ae3455feed392bef5519d53afbc562271f625bad059d0"
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
