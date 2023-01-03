class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.3.tar.gz"
  sha256 "0c00d7e839caf123c97822542d7f16e6f40267ea0c6b54ce2c868e3ae21de809"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fastmod"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "a5e11cbdd052da96782ea11197af13d2b2f03ab70281d4409091c4b9b9b9d26f"
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
