class Rav1e < Formula
  desc "Fastest and safest AV1 video encoder"
  homepage "https://github.com/xiph/rav1e"
  url "https://github.com/xiph/rav1e/archive/v0.5.1.tar.gz"
  sha256 "7b3060e8305e47f10b79f3a3b3b6adc3a56d7a58b2cb14e86951cc28e1b089fd"
  license "BSD-2-Clause"
  head "https://github.com/xiph/rav1e.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rav1e"
    sha256 cellar: :any, mojave: "33336cbbe2a94d7739be33d2555fab6310a618a3e1096b3ebf04001af1dd68a0"
  end

  depends_on "cargo-c" => :build
  depends_on "nasm" => :build
  depends_on "rust" => :build

  resource "bus_qcif_7.5fps.y4m" do
    url "https://media.xiph.org/video/derf/y4m/bus_qcif_7.5fps.y4m"
    sha256 "1f5bfcce0c881567ea31c1eb9ecb1da9f9583fdb7d6bb1c80a8c9acfc6b66f6b"
  end

  def install
    system "cargo", "install", *std_cargo_args
    system "cargo", "cinstall", "--prefix", prefix
  end

  test do
    resource("bus_qcif_7.5fps.y4m").stage do
      system "#{bin}/rav1e", "--tile-rows=2",
                                   "bus_qcif_7.5fps.y4m",
                                   "--output=bus_qcif_15fps.ivf"
    end
  end
end
