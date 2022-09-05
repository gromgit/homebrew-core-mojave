class Duf < Formula
  desc "Disk Usage/Free Utility - a better 'df' alternative"
  homepage "https://github.com/muesli/duf"
  url "https://github.com/muesli/duf/archive/v0.8.1.tar.gz"
  sha256 "ebc3880540b25186ace220c09af859f867251f4ecaef435525a141d98d71a27a"
  license "MIT"
  head "https://github.com/muesli/duf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/duf"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "27246f7706c37ef8820ede07b217458b075b9d4a13924ef7f16654ac18817530"
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
