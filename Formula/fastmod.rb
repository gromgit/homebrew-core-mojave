class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.3.tar.gz"
  sha256 "0c00d7e839caf123c97822542d7f16e6f40267ea0c6b54ce2c868e3ae21de809"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fastmod"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "388466c329dcd8dc5e0f757c58c877c0db27ef1781e0fc58c8708fdc7ebe4c05"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"input.txt").write("Hello, World!")
    system bin/"fastmod", "-d", testpath, "--accept-all", "World", "fastmod"
    assert_equal "Hello, fastmod!", (testpath/"input.txt").read
  end
end
