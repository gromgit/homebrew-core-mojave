class Kalker < Formula
  desc "Full-featured calculator with math syntax"
  homepage "https://kalker.strct.net"
  url "https://github.com/PaddiM8/kalker/archive/v2.0.0.tar.gz"
  sha256 "092ab13726515125ec3664c15e61fa7b8eec09ad590f0c5ef00df6e33b3b3da7"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kalker"
    sha256 cellar: :any_skip_relocation, mojave: "f5c1adcf8e77df911504959075d5e8b0f4d59e4af6effff725a26de9e9fbe637"
  end

  depends_on "rust" => :build

  uses_from_macos "m4" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_equal shell_output("#{bin}/kalker 'sum(n=1, 3, 2n+1)'").chomp, "15"
  end
end
